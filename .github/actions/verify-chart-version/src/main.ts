import * as core from '@actions/core';
import * as github from '@actions/github';
import * as YAML from 'yaml';

const fs = require('fs-extra');

function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message;
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

    const octokit = github.getOctokit(githubToken);
    try {
      const originalChartYamlContent = await octokit.rest.repos.getContent({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        path: `${chartYamlPath}z`
      })
    }
    catch (error){
      if (error instanceof Error) {
        core.info(error.name);
        core.setFailed(getErrorMessage(error));
      }
    }

    const updatedChartYamlContent = await fs.readFile(chartYamlPath, 'utf8');
    const updatedChartYaml = await YAML.parse(updatedChartYamlContent);
    if (!updatedChartYaml.version) {
      core.setFailed(`${chartYamlPath} does not contain a version!`);
      return;
    }
    core.info(`New version: ${updatedChartYaml.version}`);
  }
  catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run()
