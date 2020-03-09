delete(daqfind)
%%
ai = analoginput('advantech');
chans = addchannel(ai,4);
set(ai,'SampleRate',1)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger', ActualRate)
set(ai,'LoggingMode','Disk&Memory')
set(ai,'LogFileName','data.daq')
ai.channel.InputRange = [-0.05 0.05];
%%
start(ai)
%%
[data,time] = daqread('data.daq');
%%
stop(ai)