#!/usr/bin/env zx
import 'zx/globals'
const chart = argv["_"][0]

argv.debug ? $.verbose = true : $.verbose = false

if (chart == undefined) {
  console.log(chalk.redBright(`ERROR: `) + `No chart provided to validate!`)
  process.exit(1)
}

const defaultBranch = argv.default_branch || await $`git remote show origin | awk '/HEAD branch/ {print $NF}'`
const chartYamlPath = `${chart}/Chart.yaml`

if (!await fs.pathExists(chartYamlPath)) {
  console.log(chalk.redBright(`ERROR: `) + `${chartYamlPath} does not exist!`)
  process.exit(1)
}

const getOriginalChartYamlProcessOutput = await $`git show origin/${defaultBranch}:./${chartYamlPath}`
const originalChartYamlContent = Buffer.from(getOriginalChartYamlProcessOutput.stdout, 'utf-8').toString();
const originalChartYaml = await YAML.parse(originalChartYamlContent)
echo `Original version: ${originalChartYaml.version}`

const updatedChartYamlContent = await fs.readFile(chartYamlPath, 'utf8')
const updatedChartYaml = await YAML.parse(updatedChartYamlContent)
if (!updatedChartYaml.version) {
  console.log(chalk.redBright(`ERROR: `) + `${chartYamlPath} does not contain a version!`)
  process.exit(1)
}
echo `New version: ${updatedChartYaml.version}`

if (updatedChartYaml.version == originalChartYaml.version) {
  console.log(chalk.redBright(`ERROR: `) + `Chart version has not been updated!`)
  process.exit(1)
} else {
  console.log(chalk.greenBright(`OK: `) + `Chart version has been updated!`)
}
