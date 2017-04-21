--[[
    Zeiler FRCNN model.
]]

require 'nn'
require 'cudnn'
require 'inn'

------------------------------------------------------------------------------------------------------------

local function CreateModel()

    -- load features + model parameters (mean/std,stride/num feats (last conv)/colorspace format)
    local net = torch.load(projectDir .. '/data/pretrained_models/model_zeilernet.t7')
    local net = torch.load(projectDir .. '/data/pretrained_models/parameters_zeilernet.t7')
    local features = net.modules[1]

    return features, model_parameters
end

return CreateModel