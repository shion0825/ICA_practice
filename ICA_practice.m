clc; close all; clear;


signal1 = audioread("speech\speech_mix1.wav");
signal2 = audioread("speech\speech_mix2.wav");

speech = [signal1.'; signal2.'];
infoSpeech = audioinfo("speech\speech_mix1.wav");

signal1 = audioread("music\music_mix1.wav");
signal2 = audioread("music\music_mix2.wav");
signal3 = audioread("music\music_mix3.wav");

music = [signal1.'; signal2.'; signal3.'];
infoMusic = audioinfo("music\music_mix1.wav");


% BSS(speech, 0.5, 50, infoSpeech.TotalSamples, infoSpeech.SampleRate);
tic
BSS(music, 0.3, 50, infoMusic.TotalSamples, infoMusic.SampleRate);
toc