import * as core from '@actions/core';
import * as github from '@actions/github';

async function run() {
  if (github.context.eventName !== "pull_request") {
    core.info("This function Can only run on pull requests!");
    return;
  }

  const githubToken = core.getInput("token");
  const chart = core.getInput('chart');
}

run()
  .catch(error => core.setFailed("Workflow failed! " + error.message));
