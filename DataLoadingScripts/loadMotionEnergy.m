function me = loadMotionEnergy(obj,meta,params,datapth)


%------------------------------------------------------------
% --first check to see if obj has an 'me' and has thresh--
% -----------------------------------------------------------
if isfield(obj,'me') && isstruct(obj.me)
    me = obj.me;
    return
end
% -----------------------------------------------------------
% -- if not, loadMotionEnergy, and save it it to obj.me--
% -----------------------------------------------------------

% find and load motion energy .mat file
mepth = fullfile(datapth,'DataObjects',meta.anm);
contents = dir(mepth);
contents = contents(~[contents.isdir]);

fns = {contents.name}';

fn = patternMatchCellArray({contents.name}',{'motionEnergy',meta.date},'all');

if numel(fn) == 1
    fn = fn{1};
elseif numel(fn) == 2
    ix = ~contains(fn,'._'); % on windows, sometimes a file that starts with '._motionEnergy*' is found
    fn = fn{ix};
else
    disp('UNABLE TO LOCATE A MOTION ENERGY FILE IN: ')
    disp(mepth)
    disp('      Continuing without motion energy as a feature')
    me.use = 0;
    me.data = nan;
    me.moveThresh = nan;
    return
end

temp = load(fullfile(mepth,fn));
me = temp.me;

if isstruct(me.data)
    me.data = me.data.data;
end


% -----------------------------------------------------------
% trim trial length (me.data contains motion energy for each time point in
% trial at 400 Hz). Want to align to params.alignEvent and want to put it
% in same dt as neural data
% -----------------------------------------------------------
taxis = obj.time;
alignTimes = obj.bp.ev.(params.alignEvent);
me.newdata = zeros(numel(obj.time),numel(me.data));
for trix = 1:numel(me.data)
    try
        me.newdata(:,trix) = interp1(obj.traj{1}(trix).frameTimes-0.5-alignTimes(trix),me.data{trix},taxis); % interp1(old_time,me,new_time);
    catch % if frameTimes doesn't exist or is full of NaNs - shouldn't be dummy data as we aren't using those sessions
        frameTimes = (1:size(obj.traj{1}(trix).ts,1)) ./ 400;
        me.newdata(:,trix) = interp1(frameTimes-0.5-alignTimes(trix),me.data{trix},taxis);
    end
end

% replace me.data with me.newdata
me.data = me.newdata;
me = rmfield(me,'newdata');
% fill nans with nearest value (there are some nans at the start of each
% trial)
me.data = fillmissing(me.data,'nearest');

% -------------------------------------------------------------------
% -- assign move time points as logical array same size as me.data --
% -------------------------------------------------------------------
me.move = me.data > (me.moveThresh);

end % loadMotionEnergy













