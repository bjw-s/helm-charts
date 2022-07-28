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

    const updatedChartYamlContent = await fs.readFile(chartYamlPath, 'utf8');
    const updatedChartYaml = await YAML.parse(updatedChartYamlContent);
    if (!updatedChartYaml.version) {
      core.setFailed(`${chartYamlPath} does not contain a version!`);
      return;
    }

    var originalChartYamlFile;
    const octokit = github.getOctokit(githubToken);
    try {
      originalChartYamlFile = await octokit.rest.repos.getContent({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        path: `${chartYamlPath}`
      });
    }
    catch (error){
      core.warning(`Could not find original Chart.yaml for ${chart}, assuming this is a new chart.`);
    }

    if (originalChartYamlFile && "content" in originalChartYamlFile.data){
      const originalChartYamlContent = originalChartYamlFile.data.content.toString();
      const originalChartYaml = await YAML.parse(originalChartYamlContent)
      core.info(`Old chart version: ${originalChartYaml.version}`);

      if (updatedChartYaml.version == originalChartYaml.version) {
        core.info(`Chart version has not been updated!`)
      }
    }

    core.info(`New chart version: ${updatedChartYaml.version}`);
  }
  catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run()
