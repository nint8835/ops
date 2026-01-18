.PHONY: generate-models
generate-models:
	datamodel-codegen --url https://raw.githubusercontent.com/mostlygeek/llama-swap/refs/heads/main/config-schema.json --input-file-type jsonschema --output llm_config_generator/config_models/llama_swap.py --output-model-type pydantic_v2.BaseModel --formatters ruff-format ruff-check
