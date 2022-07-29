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
  base: string,
  head: string,
  githubToken: string
) {
  let result: string[] = [];
  const octokit = github.getOctokit(githubToken);

  // Use GitHub's compare two commits API.
  const response = await octokit.rest.repos.compareCommits({
    base,
    head,
    owner: github.context.repo.owner,
    repo: github.context.repo.repo,
  });

  // Ensure that the request was successful.
  if (response.status !== 200) {
    throw new Error(
      `The GitHub API for comparing the base and head commits for this PR event returned ${response.status}, expected 200.`
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
    const absoluteChartFolder = path.resolve(path.dirname(file));
    const chart = absoluteChartFolder.slice(absoluteParentFolder.length + 1);
    changedCharts.push(chart);
  });

  // Return only unique items
  return changedCharts.filter(
    (item, index) => changedCharts.indexOf(item) === index
  );
}

async function run() {
  try {
    if (github.context.eventName !== "pull_request") {
      throw new Error("This action can only run on pull requests!");
    }

    const githubToken = core.getInput("token", { required: true });
    const chartsFolder = core.getInput("chartsFolder", { required: true });
    const repoConfigFilePath = core.getInput("repoConfigFile", {
      required: true,
    });

    const repoConfig = await getRepoConfig(repoConfigFilePath);
    core.info(
      `Repo configuration: ${JSON.stringify(repoConfig, undefined, 2)}`
    );

    // Define the base and head commits to be extracted from the payload.
    const baseCommit = github.context.payload.pull_request?.base?.sha;
    const headCommit = github.context.payload.pull_request?.head?.sha;

    // Ensure that the base and head properties are set on the payload.
    if (!baseCommit || !headCommit) {
      throw new Error(
        `The base and head commits are missing from the payload for this PR.`
      );
    }

    core.info(`Base commit: ${baseCommit}`);
    core.info(`Head commit: ${headCommit}`);

    const responseFiles = await requestAddedModifiedFiles(
      baseCommit,
      headCommit,
      githubToken
    );
    const changedCharts = filterChangedCharts(responseFiles, chartsFolder);
    const chartsToInstall = changedCharts.filter(
      (x) => !repoConfig["excluded-charts-install"].includes(x)
    );
    const chartsToLint = changedCharts.filter(
      (x) => !repoConfig["excluded-charts-lint"].includes(x)
    );

    core.info(`Changed charts: ${JSON.stringify(changedCharts, undefined, 2)}`);
    core.info(`Charts to lint: ${JSON.stringify(chartsToLint, undefined, 2)}`);
    core.info(
      `Charts to install: ${JSON.stringify(chartsToInstall, undefined, 2)}`
    );

    core.setOutput("changedCharts", changedCharts);
    core.setOutput("chartsToInstall", chartsToInstall);
    core.setOutput("chartsToLint", chartsToLint);
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
