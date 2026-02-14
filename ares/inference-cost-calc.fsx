[<Measure>] type kW
[<Measure>] type W
[<Measure>] type s
[<Measure>] type h
[<Measure>] type CAD
[<Measure>] type Tokens

let powerCost = 0.15213<CAD/(kW * h)>
let inferencePowerConsumption = 100.0<W> * 0.1<kW/W>

let promptProcessingTokensPerSecond = 149.64<Tokens/s>
let generationTokensPerSecond = 48.13<Tokens/s>

let inputCostPerMillionTokens = 
    1000000.0<Tokens> / promptProcessingTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

let outputCostPerMillionTokens = 
    1000000.0<Tokens> / generationTokensPerSecond
    / 3600.0<s/h>
    * inferencePowerConsumption
    * powerCost

printfn "Input cost per million tokens: %A CAD" inputCostPerMillionTokens
printfn "Output cost per million tokens: %A CAD" outputCostPerMillionTokens
