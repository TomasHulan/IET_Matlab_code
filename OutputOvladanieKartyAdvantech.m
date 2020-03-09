%% zastavenie 
if (~isempty(daqfind))
    stop(daqfind)
end
%% advantech
ao = analogoutput('advantech');
%%
addchannel(ao,0);
set(ao,'TriggerType','Immediate');
%%
set(ao,'SampleRate',1);
%%
putsample(ao,0)
%%
putsample(ao,4.7)

