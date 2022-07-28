import * as core from '@actions/core';
import * as github from '@actions/github';

const fs = require('fs-extra');

function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message
  return String(error)
}

async function run() {
  try {
    if (github.context.eventName !== "pull_request") {
      core.setFailed("Can only run on pull requests!");
      return;
    }

    const githubToken = core.getInput("token");
    const chart = core.getInput('chart', { required: true });
    const chartYamlPath = `${chart}/Chart.yaml`;
    if (!await fs.pathExists(chartYamlPath)) {
      core.setFailed(`${chart} is not a valid Helm chart folder!`);
      return;
    }
  }
  catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run()
