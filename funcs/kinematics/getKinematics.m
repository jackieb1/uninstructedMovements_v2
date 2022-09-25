function kin = getKinematics(obj,me,params)

% ----------------------------------------------
% -- Check if obj already has kin --
% ----------------------------------------------
if isfield(obj,'kin')
    if isfield(params,'reload_kin')
        if params.reload_kin
            % get kinematics
        else
            return % kin = obj.kin
        end
    end
    return % kin = obj.kin
else
    % get kinematics
end


% ----------------------------------------------
% -- Kinematics --
% (xdisp,ydisp,xvel,yvel) for each dlc feature
% ----------------------------------------------
[kin.dat,kin.featLeg] = getKinematicsFromVideo(obj,params);

% ----------------------------------------------
% -- Tongue angle and length --
% ----------------------------------------------
if ismember('tongue',params.traj_features{1})
    [ang,len] = getLickAngleAndLength(kin.featLeg,kin.dat);
    kin.featLeg{end+1} = 'tongue_angle';
    kin.featLeg{end+1} = 'tongue_length';

    kin.dat(:,:,end+1) = ang;
    kin.dat(:,:,end+1) = len;
end

% ----------------------------------------------
% -- Motion energy --
% ----------------------------------------------
kin.featLeg{end+1} = 'motion_energy';

kin.dat(:,:,end+1) = me.data;

% ----------------------------------------------
% -- Standardize kinematics --
% commented out b/c pca centers data for us
% ----------------------------------------------
% for featix = 1:size(kin.dat,3)
%     temp = kin.dat(:,:,featix);
%     kin.dat(:,:,featix) = (temp - mean(temp,2,'omitnan')) ./ std(temp,[],'omitnan');
% end

% ----------------------------------------------
% -- DIMENSIONALITY REDUCTION --
% ----------------------------------------------
% many of the video features will be highly correlated, so we will perform PCA/FA
% on the matrix of features to reduce the dimensionality to a set of factors that
% best explain the movement captured by the video recordings
kin.dat_reduced = reduceDimensionVideoFeatures(kin.dat,params.feat_varToExplain);

end

