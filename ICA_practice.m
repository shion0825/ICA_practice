clc; close all; clear;

signal1 = audioread("speech\speech_mix1.wav");
signal2 = audioread("speech\speech_mix2.wav");

speech = [signal1.'; signal2.'];
infoSpeech = audioinfo("speech\speech_mix1.wav");

%{
signal1 = audioread("music\music_mix1.wav");
signal2 = audioread("music\music_mix2.wav");
signal3 = audioread("music\music_mix3.wav");

music = [signal1.'; signal2.'; signal3.'];
infoMusic = audioinfo("music\music_mix1.wav");
%}


% サブフォルダーにパスを通す
addpath('./bss_eval');

[estSig1, estSig2] = BSS(speech, 0.5, 50, infoSpeech.SampleRate);

% BSS(music, 0.3, 50, infoMusic.SampleRate);

mixSig = signal1;
refSig1 = audioread("speech\speech_female.wav");
refSig2 = audioread("speech\speech_male.wav");

% 入力SDRと入力SIRの計算（入力SARは∞なので不要）
[inSDR, inSIR, ~] = bss_eval_sources([mixSig, mixSig].', [refSig1, refSig2].');

% 客観評価尺度算出（SDR，SIR，SAR）
[outSDR, outSIR, SAR] = bss_eval_sources([estSig1, estSig2].', [refSig1, refSig2].');
outSDR % 信号対歪み比（source-to-distortion ratio），分離音源の音質と分離度合いの両方を含む尺度（分離はできているけど音がボロボロだと低い）
outSIR % 信号対干渉比（source-to-interference ratio），分離音源の分離度合いのみを含む尺度（音はボロボロだけど相手の音源が消えていれば高い）
SAR % 信号群対人工歪み比（sources-to-artificial ratio），分離音源の音質のみを含む尺度（分離度合いは関係なく，とにかく人工歪みの少なさ．estSig1 = mixSigならSAR=∞dB）
% SDRはSIRとSARの両方を含む尺度なので，SDRが向上すれば音源分離手法としては優秀．両音源の平均SDRが10dBを超えてくるとまあまあ頑張っている，20dBを超えるとめちゃくちゃすごい．
% 混合が等パワーで無い場合は観測時点のSDRとSIR（「入力SDR」及び「入力SIR」と呼ぶ）をあらかじめ計算しておいて，上記の値から引き算して「改善値」を算出する
SDRimp = outSDR - inSDR % 信号対歪み比（source-to-distortion ratio）の改善量（入力SDRからの増分）
SIRimp = outSIR - inSIR % 信号対干渉比（source-to-interference ratio）の改善量（入力SDRからの増分）
SAR % 信号群対人工歪み比（sources-to-artificial ratio
