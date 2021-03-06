--[[
    Benchmark a trained model using the caltech evaluation code.
]]


require 'paths'
require 'torch'
local fastrcnn = require 'fastrcnn'

torch.setdefaulttensortype('torch.FloatTensor')
paths.dofile('projectdir.lua')


--------------------------------------------------------------------------------
-- Load options
--------------------------------------------------------------------------------

print('==> (1/6) Load options')
local opts = paths.dofile('options.lua')
local opt = opts.parse(arg)


--------------------------------------------------------------------------------
-- Load dataset data loader
--------------------------------------------------------------------------------

print('==> (2/6) Load dataset data loader')
local data_loader = paths.dofile('data.lua')
if string.match(opt.dataset, 'caltech') then
    opt.dataset = 'caltech'
end
local data_gen = data_loader(opt.dataset, 'test')
local data, data_dir = data_gen()


--------------------------------------------------------------------------------
-- Load regions-of-interest (RoIs)
--------------------------------------------------------------------------------

print('==> (3/6) Load roi proposals data')
local rois_loader = paths.dofile('rois.lua')
local rois = rois_loader(opt.dataset, opt.proposalAlg, 'test')


--------------------------------------------------------------------------------
-- Setup model
--------------------------------------------------------------------------------

print('==> (4/6) Load model: ' .. opt.load)
local model, model_parameters = unpack(torch.load(opt.load))
if pcall(require, 'cudnn') then
    cudnn.convert(model, cudnn)
end


--------------------------------------------------------------------------------
-- Setup detector class
--------------------------------------------------------------------------------

print('==> (5/6) Setup detector')
local imdetector = fastrcnn.ImageDetector(model, model_parameters, opt) -- single image detector/tester


--------------------------------------------------------------------------------
-- Benchmark network
--------------------------------------------------------------------------------

print('==> (6/6) Benchmark algorithm')
local utils = paths.dofile('utils.lua')
utils.benchmark(data, rois, imdetector, data_dir, opt)

print('Script complete.')