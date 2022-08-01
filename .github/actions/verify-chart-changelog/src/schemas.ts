import Ajv from "ajv";
import addFormats from "ajv-formats";

export const changelogEntrySchema = {
  type: "object",
  properties: {
    kind: {
      type: "string",
      enum: ["added", "changed", "deprecated", "removed", "fixed", "security"],
    },
    description: { type: "string" },
    links: {
      type: "array",
      items: {
        type: "object",
        properties: {
          name: { type: "string" },
          url: { $ref: "#/definitions/saneUrl" },
        },
        required: ["name", "url"],
        additionalProperties: false,
      },
    },
  },
  required: ["kind", "description"],
  additionalProperties: false,
  definitions: {
    saneUrl: {
      type: "string",
      format: "uri",
      pattern: "^https?://",
    },
  },
} as const;

export function validateAgainstJsonSchema(object: any, schema: typeof changelogEntrySchema) {
  const ajv = new Ajv();
  addFormats(ajv);
  const validator = ajv.compile(schema);
  return {
    valid: validator(object),
    errors: validator.errors,
  };
}
