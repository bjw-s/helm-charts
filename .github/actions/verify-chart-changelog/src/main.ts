import * as core from "@actions/core";
import * as github from "@actions/github";
import * as YAML from "yaml";
import { validateAgainstJsonSchema, changelogEntrySchema } from "./schemas";
import { FromSchema } from "json-schema-to-ts";
import * as fs from "fs-extra";

function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message;
  return String(error);
}

function getChangelogFromYaml(chartYaml: any): string | undefined {
  const changelogAnnotation = "artifacthub.io/changes";
  if (chartYaml.annotations) {
    if (chartYaml.annotations[changelogAnnotation]) {
      return chartYaml.annotations[changelogAnnotation];
    }
  }
  return undefined;
}

async function getChartYamlFromRepo(
  path: string,
  ref: string,
  token: string
): Promise<any> {
  let result = {};
  const octokit = github.getOctokit(token);
  const chartYamlFile = await octokit.rest.repos.getContent({
    owner: github.context.repo.owner,
    repo: github.context.repo.repo,
    path: `${path}`,
    ref: ref,
  });

  if (chartYamlFile && "content" in chartYamlFile.data) {
    const originalChartYamlContent = Buffer.from(
      chartYamlFile.data.content,
      "base64"
    ).toString("utf-8");
    result = await YAML.parse(originalChartYamlContent);
  }
  return result;
}

async function getChartYamlFromFile(path: string): Promise<any> {
  const chartYamlFile = await fs.readFile(path, "utf8");
  return YAML.parse(chartYamlFile);
}

async function checkRefExists(ref: string, token: string): Promise<boolean> {
  const octokit = github.getOctokit(token);
  try {
    await octokit.rest.git.getRef({
      owner: github.context.repo.owner,
      repo: github.context.repo.repo,
      ref: ref,
    });
  } catch (error) {
    core.setFailed(`Ref ${ref} was not found for this repository!`);
    return false;
  }
  return true;
}

type changelogEntry = FromSchema<typeof changelogEntrySchema>;

async function run() {
  try {
    if (github.context.eventName !== "pull_request") {
      core.setFailed("This action can only run on pull requests!");
      return;
    }

    // Gather inputs
    const githubToken = core.getInput("token");
    const chart = core.getInput("chart", { required: true });
    const base = core.getInput("base", { required: false });

    // Verify the base ref exists
    if (base && !(await checkRefExists(base, githubToken))) {
      core.setFailed(`Ref ${base} was not found for this repository!`);
      return;
    }

    // Determine the default branch
    const defaultBranch = github.context.payload.repository?.default_branch;

    // Validate the chart
    const chartYamlPath = `${chart}/Chart.yaml`;

    if (!(await fs.pathExists(chartYamlPath))) {
      core.setFailed(`${chart} is not a valid Helm chart folder!`);
      return;
    }

    var originalChartYaml;
    var originalChartChangelog: string | undefined;
    try {
      originalChartYaml = await getChartYamlFromRepo(
        chartYamlPath,
        base || `heads/${defaultBranch}`,
        githubToken
      );
      originalChartChangelog = getChangelogFromYaml(originalChartYaml);
    } catch (error) {
      core.warning(
        `Could not find original Chart.yaml for ${chart}, assuming this is a new chart.`
      );
    }

    const updatedChartYaml = await getChartYamlFromFile(chartYamlPath);
    const updatedChartChangelog = getChangelogFromYaml(updatedChartYaml);
    if (!updatedChartChangelog) {
      core.setFailed(`${chartYamlPath} does not contain a changelog!`);
      return;
    }

    // Check if the changelog was updated
    if (originalChartChangelog) {
      if (updatedChartChangelog == originalChartChangelog) {
        core.setFailed(
          `Chart changelog has not been updated!`
        );
        return;
      }
    }

    // Validate the changelog entries
    const changelogEntries: changelogEntry[] = YAML.parse(
      updatedChartChangelog
    );
    changelogEntries.forEach((entry: changelogEntry) => {
      const validator = validateAgainstJsonSchema(entry, changelogEntrySchema);
      if (!validator.valid) {
        validator.errors?.forEach((error: any) => {
          core.setFailed(
            `${chart} changelog validation failed: ${JSON.stringify(error)}`
          );
        });
      }
    });
  } catch (error) {
    core.setFailed(getErrorMessage(error));
  }
}

run();
