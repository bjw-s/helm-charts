import * as core from "@actions/core";
import * as github from "@actions/github";
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
    }
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
