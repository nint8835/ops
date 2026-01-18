import yaml

from llm_config_generator import DiffusionModel

with open("test_output.yaml", "w") as f:
    yaml.dump(
        DiffusionModel(
            id="flux-2-klein-4b",
            display_name="FLUX.2 [klein] (4B)",
            diffusion_model_path="/models/stable-diffusion/flux-2-klein-4b-BF16.gguf",
            vae_path="/models/stable-diffusion/flux-2-klein-vae.safetensors",
            text_encoder_path="/models/Qwen3-4B-BF16.gguf",
            cfg_scale=1.0,
            steps=4,
            extra_args=["--diffusion-fa"],
        )
        .to_llama_swap_config()
        .model_dump(),
        f,
    )
