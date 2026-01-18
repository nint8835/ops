from pydantic import BaseModel, Field

from .config_models.llama_swap import Models as LlamaSwapModel


class BaseInferenceModel(BaseModel):
    id: str
    display_name: str
    extra_args: list[str] = Field(default_factory=list)

    def to_llama_swap_config(self) -> LlamaSwapModel:
        return LlamaSwapModel(name=self.display_name, cmd="PLACEHOLDER")


class LargeLanguageModel(BaseInferenceModel):
    path: str
    context_size: int | None = None

    def to_llama_swap_config(self) -> LlamaSwapModel:
        base_config = super().to_llama_swap_config()

        args = ["${llama-server}", f"-m {self.path}"]

        if self.context_size is not None:
            args.append(f"-c {self.context_size}")

        if self.extra_args:
            args.extend(self.extra_args)

        base_config.cmd = " ".join(args)

        return base_config


class DiffusionModel(BaseInferenceModel):
    diffusion_model_path: str
    vae_path: str | None = None
    text_encoder_path: str | None = None
    cfg_scale: float | None = None
    steps: int | None = None

    def to_llama_swap_config(self) -> LlamaSwapModel:
        base_config = super().to_llama_swap_config()

        base_config.checkEndpoint = "/"

        args = [
            "${sd-server}",
            f"--diffusion-model {self.diffusion_model_path}",
        ]

        if self.vae_path is not None:
            args.append(f"--vae {self.vae_path}")

        if self.text_encoder_path is not None:
            args.append(f"--llm {self.text_encoder_path}")

        if self.cfg_scale is not None:
            args.append(f"--cfg-scale {self.cfg_scale}")

        if self.steps is not None:
            args.append(f"--steps {self.steps}")

        if self.extra_args:
            args.extend(self.extra_args)

        base_config.cmd = " ".join(args)

        return base_config
