import * as core from "@actions/core";
import * as github from "@actions/github";
import * as path from "path";
import * as YAML from "yaml";
import * as fs from "fs-extra";

function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message;
  return String(error);
}

async function run() {
  try {
    if (github.context.eventName !== "pull_request") {
      core.setFailed("This action can only run on pull requests!");
      return;
    }

    const githubToken = core.getInput("token", { required: true });
    const chartsFolder = core.getInput("chartsFolder", { required: true });
    const repoConfigFilePath = core.getInput("repoConfigFile", {
      required: true,
    });

    // Ensure that the repo config file exists.
    if (!(await fs.pathExists(repoConfigFilePath))) {
      core.setFailed(`${repoConfigFilePath} Does not exist!`);
      return;
    }

    // Define the base and head commits to be extracted from the payload.
    let base = github.context.payload.pull_request?.base?.sha;
    let head = github.context.payload.pull_request?.head?.sha;
    core.info(`Base commit: ${base}`);
    core.info(`Head commit: ${head}`);

    // Ensure that the base and head properties are set on the payload.
    if (!base || !head) {
      core.setFailed(
        `The base and head commits are missing from the payload for this PR.`
      );
      return;
    }

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
      core.setFailed(
        `The GitHub API for comparing the base and head commits for this PR event returned ${response.status}, expected 200.`
      );
      return;
    }

    // Ensure that the head commit is ahead of the base commit.
    if (response.data.status !== "ahead") {
      core.setFailed(
        `The head commit for this ${github.context.eventName} event is not ahead of the base commit.`
      );
      return;
    }

    // Get the changed files from the response payload.
    const addedModifiedChartFiles = response.data.files?.filter((file) => {
      let result: string[] = [];
      const filename = file.filename;
      if (path.dirname(filename).startsWith(`${chartsFolder}/`)) {
        result.push(file.filename);
      }
      return result;
    });
    core.info(JSON.stringify(addedModifiedChartFiles));
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
