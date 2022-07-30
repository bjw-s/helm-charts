import * as core from "@actions/core";
import * as github from "@actions/github";
import * as path from "path";
import * as YAML from "yaml";
import * as fs from "fs-extra";

type FileStatus = "added" | "modified" | "removed" | "renamed";

function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message;
  return String(error);
}

async function requestAddedModifiedFiles(
  baseCommit: string,
  headCommit: string,
  githubToken: string
) {
  let result: string[] = [];
  const octokit = github.getOctokit(githubToken);

  core.info(`Base commit: ${baseCommit}`);
  core.info(`Head commit: ${headCommit}`);

  // Use GitHub's compare two commits API.
  const response = await octokit.rest.repos.compareCommits({
    base: baseCommit,
    head: headCommit,
    owner: github.context.repo.owner,
    repo: github.context.repo.repo,
  });

  // Ensure that the request was successful.
  if (response.status !== 200) {
    throw new Error(
      `The GitHub API returned ${response.status}, expected 200.`
    );
  }

  // Ensure that the head commit is ahead of the base commit.
  if (response.data.status !== "ahead") {
    throw new Error(
      `The head commit for this ${github.context.eventName} event is not ahead of the base commit.`
    );
  }

  const responseFiles = response.data.files || [];
  responseFiles.forEach((file) => {
    const filestatus = file.status as FileStatus;
    if (filestatus == "added" || filestatus == "modified") {
      result.push(file.filename);
    }
  });
  return result;
}

async function requestAllFiles(commit: string, githubToken: string) {
  let result: string[] = [];
  const octokit = github.getOctokit(githubToken);

  core.info(`Commit SHA: ${commit}`);

  const response = await octokit.rest.git.getTree({
    tree_sha: commit,
    owner: github.context.repo.owner,
    repo: github.context.repo.repo,
    recursive: "true",
  });

  // Ensure that the request was successful.
  if (response.status !== 200) {
    throw new Error(
      `The GitHub API returned ${response.status}, expected 200.`
    );
  }

  const responseTreeItems = response.data.tree || [];
  responseTreeItems.forEach((item) => {
    if (item.type == "blob" && item.path) {
      result.push(item.path);
    }
  });
  return result;
}

async function getRepoConfig(configPath: string) {
  // Ensure that the repo config file exists.
  if (!(await fs.pathExists(configPath))) {
    throw new Error(`${configPath} Does not exist!`);
  }

  const repoConfigRaw = await fs.readFile(configPath, "utf8");
  const repoConfig = await YAML.parse(repoConfigRaw);
  return repoConfig;
}

function filterChangedCharts(files: string[], parentFolder: string) {
  const filteredChartFiles = files.filter((file) => {
    const rel = path.relative(parentFolder, file);
    return !rel.startsWith("../") && rel !== "..";
  });

  let changedCharts: string[] = [];
  filteredChartFiles.forEach((file) => {
    const absoluteParentFolder = path.resolve(parentFolder);
    const absoluteFileDirname = path.resolve(path.dirname(file));
    const relativeFileDirname = absoluteFileDirname.slice(
      absoluteParentFolder.length + 1
    );
    const chartPathParts = relativeFileDirname.split("/");
    const chart = `${chartPathParts[0]}/${chartPathParts[1]}`;
    changedCharts.push(chart);
  });

  // Return only unique items
  return changedCharts.filter(
    (item, index) => changedCharts.indexOf(item) === index
  );
}

async function run() {
  try {
    const githubToken = core.getInput("token", { required: true });
    const chartsFolder = core.getInput("chartsFolder", { required: true });
    const repoConfigFilePath = core.getInput("repoConfigFile", {
      required: true,
    });
    let getAllCharts = core.getInput("getAllCharts", { required: false });
    const overrideCharts = core.getInput("overrideCharts", { required: false });

    const repoConfig = await getRepoConfig(repoConfigFilePath);
    core.info(
      `Repo configuration: ${JSON.stringify(repoConfig, undefined, 2)}`
    );

    if (overrideCharts && overrideCharts != '[]') {
      const responseCharts = YAML.parse(overrideCharts);
      core.info(`Charts: ${JSON.stringify(responseCharts, undefined, 2)}`);
      core.setOutput("charts", responseCharts);
      return;
    }

    const eventName = github.context.eventName;

    let baseCommit: string;
    let headCommit: string;

    switch (eventName) {
      case "pull_request":
        baseCommit = github.context.payload.pull_request?.base?.sha;
        headCommit = github.context.payload.pull_request?.head?.sha;
        break;
      case "push":
        baseCommit = github.context.payload.before;
        headCommit = github.context.payload.after;
        break;
      case "workflow_dispatch":
        getAllCharts = "true";
        baseCommit = "";
        headCommit = github.context.sha;
        break;
      default:
        throw new Error(
          `This action only supports pull requests and pushes, ${github.context.eventName} events are not supported. `
        );
    }

    let responseFiles: string[];
    if (getAllCharts === "true") {
      responseFiles = await requestAllFiles(headCommit, githubToken);
    } else {
      responseFiles = await requestAddedModifiedFiles(
        baseCommit,
        headCommit,
        githubToken
      );
    }

    const changedCharts = filterChangedCharts(responseFiles, chartsFolder);
    const chartsToInstall = changedCharts.filter(
      (x) => !repoConfig["excluded-charts-install"].includes(x)
    );
    const chartsToLint = changedCharts.filter(
      (x) => !repoConfig["excluded-charts-lint"].includes(x)
    );

    core.info(`Charts: ${JSON.stringify(changedCharts, undefined, 2)}`);
    core.info(`Charts to lint: ${JSON.stringify(chartsToLint, undefined, 2)}`);
    core.info(
      `Charts to install: ${JSON.stringify(chartsToInstall, undefined, 2)}`
    );

    core.setOutput("charts", changedCharts);
    core.setOutput("chartsToInstall", chartsToInstall);
    core.setOutput("chartsToLint", chartsToLint);
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
