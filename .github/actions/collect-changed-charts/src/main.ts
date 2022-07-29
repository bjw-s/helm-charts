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

    const githubToken = core.getInput("token", {required: true});

    const repoConfigFilePath = core.getInput("token", {required: true})
    // Ensure that the repo config file exists.
    if (!(await fs.pathExists(repoConfigFilePath))) {
      core.setFailed(`${repoConfigFilePath} Does not exist!`);
      return;
    }

  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
