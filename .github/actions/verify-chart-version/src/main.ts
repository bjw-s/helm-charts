import * as core from "@actions/core";
import * as github from "@actions/github";
import * as YAML from "yaml";

import * as semver from "semver";
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

    const githubToken = core.getInput("token");
    const chart = core.getInput("chart", { required: true });
    const compareAgainstRef = core.getInput("ref");
    const chartYamlPath = `${chart}/Chart.yaml`;

    if (!(await fs.pathExists(chartYamlPath))) {
      core.setFailed(`${chart} is not a valid Helm chart folder!`);
      return;
    }

    const octokit = github.getOctokit(githubToken);

    if (compareAgainstRef) {
      try {
        await octokit.rest.git.getRef({
          owner: github.context.repo.owner,
          repo: github.context.repo.repo,
          ref: compareAgainstRef,
        });
      } catch (error) {
        core.setFailed(
          `Ref ${compareAgainstRef} was not found for this repository!`
        );
        return;
      }
    }

    var originalChartYamlFile;
    var originalChartVersion;
    try {
      originalChartYamlFile = await octokit.rest.repos.getContent({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        path: `${chartYamlPath}`,
        ref: compareAgainstRef,
      });
    } catch (error) {
      core.warning(
        `Could not find original Chart.yaml for ${chart}, assuming this is a new chart.`
      );
    }

    if (originalChartYamlFile && "content" in originalChartYamlFile.data) {
      const originalChartYamlContent = Buffer.from(
        originalChartYamlFile.data.content,
        "base64"
      ).toString("utf-8");
      const originalChartYaml = await YAML.parse(originalChartYamlContent);
      originalChartVersion = originalChartYaml.version;
    }

    const updatedChartYamlContent = await fs.readFile(chartYamlPath, "utf8");
    const updatedChartYaml = await YAML.parse(updatedChartYamlContent);
    if (!updatedChartYaml.version) {
      core.setFailed(`${chartYamlPath} does not contain a version!`);
      return;
    }
    const updatedChartVersion = updatedChartYaml.version;
    if (!semver.valid(updatedChartVersion)) {
      core.setFailed(`${updatedChartVersion} is not a valid SemVer version!`);
      return;
    }

    if (!semver.gt(updatedChartVersion, originalChartVersion)) {
      core.setFailed(
        `Updated chart version ${updatedChartVersion} is < ${originalChartVersion}!`
      );
      return;
    }

    core.info(`Old chart version: ${originalChartVersion}`);
    core.info(`New chart version: ${updatedChartVersion}`);

    if (updatedChartVersion == originalChartVersion) {
      core.setFailed(`Chart version has not been updated!`);
    }
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
