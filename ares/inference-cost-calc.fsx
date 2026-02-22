[<Measure>] type kW
[<Measure>] type W
[<Measure>] type s
[<Measure>] type h
[<Measure>] type CAD
[<Measure>] type Tokens

let powerCost = 0.15213<CAD/(kW * h)>
let inferencePowerConsumption = 100.0<W> / 1000.0<W/kW>

let promptProcessingTokensPerSecond = 1229.56<Tokens/s>
let generationTokensPerSecond = 48.06<Tokens/s>

let inputCostPerToken =
    1.0<Tokens> / promptProcessingTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

let inputCostPerMillionTokens = 
    1000000.0<Tokens> / promptProcessingTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

let outputCostPerToken =
    1.0<Tokens> / generationTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

let outputCostPerMillionTokens = 
    1000000.0<Tokens> / generationTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

printfn "Input cost per token: %A CAD" inputCostPerToken
printfn "Output cost per token: %A CAD" outputCostPerToken

printfn "Input cost per million tokens: %A CAD" inputCostPerMillionTokens
printfn "Output cost per million tokens: %A CAD" outputCostPerMillionTokens
