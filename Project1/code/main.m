%%% Basic read data and visualization for the course SM2501
%%% Biomechanics of Human Movement at KTH - 2026
%% Setup files
name_motion={'Walking'    'Jogging'   'Crouch'};
name_grf   ={'Walking_FP' 'Jogging_FP' 'Crouch_FP'};

% frame_sel  =[];

index=1; % select the motion to be loaded and visualized e.g., index=1 -> NormWalk
%% Read marker trajectory and ground reaction data
% data files should be in the same folder as the .m file
file_dir = pwd;
data_trc = readtable(fullfile(file_dir,[name_motion{index} '.csv']));
data_grf = readtable(fullfile(file_dir,[name_grf{index} '.csv']));

%% Downsample ground reaction data
% down sample the ground reaction data, so it has the same length as marker trajectory
data_grf_s = downsample(data_grf,10);
time=data_grf_s.Time;
%% Assign the uploaded table to variables in MATLAB
toMeters=1/1000; % data is originally in mm, it has to be divided by 1000 to have it in meters

RTOE_y=data_trc.RTOO_Y*toMeters;   RTOE_z=data_trc.RTOO_Z*toMeters;    % horizontal coordinate of the right toe & vertical coordinate of the right toe 
LTOE_y=data_trc.LTOO_Y*toMeters;   LTOE_z=data_trc.LTOO_Z*toMeters;    % horizontal coordinate of the left toe & vertical coordinate of the left toe 

RANKLE_y=data_trc.RAJC_Y*toMeters;   RANKLE_z=data_trc.RAJC_Z*toMeters;   
LANKLE_y=data_trc.LAJC_Y*toMeters;   LANKLE_z=data_trc.LAJC_Z*toMeters;   

RKNEE_y=data_trc.RKJC_Y*toMeters;   RKNEE_z=data_trc.RKJC_Z*toMeters;    
LKNEE_y=data_trc.LKJC_Y*toMeters;   LKNEE_z=data_trc.LKJC_Z*toMeters;   

RHIP_y=data_trc.RHJC_Y*toMeters;   RHIP_z=data_trc.RHJC_Z*toMeters;    
LHIP_y=data_trc.LHJC_Y*toMeters;   LHIP_z=data_trc.LHJC_Z*toMeters;  

PELO_y=data_trc.PELO_Y*toMeters;   PELO_z=data_trc.PELO_Z*toMeters;    
PELP_y=data_trc.PELP_Y*toMeters;   PELP_z=data_trc.PELP_Z*toMeters;   

TRXO_y=data_trc.TRXO_Y*toMeters;   TRXO_z=data_trc.TRXO_Z*toMeters;    
TRXP_y=data_trc.TRXP_Y*toMeters;   TRXP_z=data_trc.TRXP_Z*toMeters;  

FP1_force_y=data_grf_s.FP1_Force_Y;            FP1_force_z=data_grf_s.FP1_Force_Z;
FP1_COP_y  =(600 - data_grf_s.FP1_COP_Y)*toMeters;     FP1_COP_z  =data_grf_s.FP1_COP_Z*toMeters;

FP2_force_y=data_grf_s.FP2_Force_Y;            FP2_force_z=data_grf_s.FP2_Force_Z;
FP2_COP_y=(-600 - data_grf_s.FP2_COP_Y)*toMeters;       FP2_COP_z=data_grf_s.FP2_COP_Z*toMeters;

%% Run a simple animation for visualization purposes only

run_animation=false;
color_body="#0077be";
row=height(data_trc);

if run_animation==true
figure('color','w','Position', [10 10 1200 700]);

    % Start from frame 50th as the coordinates at the first few frames were
    % not processed and they are not considered in the assignment
    for i=1:5:row   
    subplot(1,1,1)
    plot([RANKLE_y(i),RTOE_y(i)],[RANKLE_z(i),RTOE_z(i)],'Color',color_body,'LineWidth',2) % creates a segment between the ankle and the toe in the right side
    hold on
    plot([RANKLE_y(i),RKNEE_y(i)],[RANKLE_z(i),RKNEE_z(i)],'Color','g','LineWidth',2)
    plot([LANKLE_y(i),LTOE_y(i)],[LANKLE_z(i),LTOE_z(i)],'Color',color_body,'LineWidth',2)
    plot([LANKLE_y(i),LKNEE_y(i)],[LANKLE_z(i),LKNEE_z(i)],'Color','r','LineWidth',2)

    plot([LHIP_y(i),LKNEE_y(i)],[LHIP_z(i),LKNEE_z(i)],'Color',color_body,'LineWidth',2)
    plot([RHIP_y(i),RKNEE_y(i)],[RHIP_z(i),RKNEE_z(i)],'Color',color_body,'LineWidth',2)
    
    plot([PELO_y(i),PELP_y(i)],[PELO_z(i),PELP_z(i)],'Color',color_body,'LineWidth',2)
    plot([TRXO_y(i),TRXP_y(i)],[TRXO_z(i),TRXP_z(i)],'Color',color_body,'LineWidth',2)

    text(RANKLE_y(i),RANKLE_z(i),'Rankle','FontSize',8)
    text(LANKLE_y(i),LANKLE_z(i),'Lankle','FontSize',8)
    text(RKNEE_y(i),RKNEE_z(i),'Rknee','FontSize',8)
    text(LKNEE_y(i),LKNEE_z(i),'Lknee','FontSize',8)
    
    %disp(knee_angle(i))

    % Compare with the previous frame, if the values of COP are changed, it
    % means the subject is stepping on that force plate and we visualize it 
    if (i>=2)
        if FP1_COP_y(i) ~= FP1_COP_y(i-1) 
            plot(FP1_COP_y(i),FP1_COP_z(i),'ok','LineWidth',2);
            quiver(FP1_COP_y(i),FP1_COP_z(i),FP1_force_y(i)/1000,FP1_force_z(i)/1000,0,'Color','r','LineWidth',2); % It is divided by 1000 for visualization purpose only
        end
        if FP2_COP_y(i) ~= FP2_COP_y(i-1)
            plot(FP2_COP_y(i),FP2_COP_z(i),'ok','LineWidth',2);
            quiver(FP2_COP_y(i),FP2_COP_z(i),FP2_force_y(i)/1000,FP2_force_z(i)/1000,0,'Color','r','LineWidth',2); % It is divided by 1000 for visualization purpose only
        end
    end

    hold off
    axis([-3.5 3.5 -0.25 3])
    xlabel("horizontal distance [m]",'FontSize',20); ylabel("vertical distance [m]",'FontSize',20)
    pause(0.1)
    end
end

%%

% Trunk
TRXO=[TRXO_y TRXO_z];
TRXP=[TRXP_y TRXP_z];
trunk=TRXO-TRXP;
Trunk_angle=atan(trunk(:,1)./trunk(:,2));

% Pelvis
PELP=[PELP_y PELP_z];
PELO=[PELO_y PELO_z];
Pelvis=PELP-PELO;
Pelvis_angle=atan(Pelvis(:,1)./Pelvis(:,2));

% Hip (right leg)
RKNEE=[RKNEE_y RKNEE_z];
RHIP=[RHIP_y RHIP_z];
femur_right=RHIP-RKNEE;
u = femur_right;
v = Pelvis;

cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!

hip_angle = atan2(cp, dp) * -1;% * 180/pi *-1;

%righthip=acos(dot(femur_right,Pelvis,2)./(vecnorm(femur_right,2,2).*vecnorm(Pelvis,2,2)))*180/pi;

%max(righthip)
%min(righthip)

% Knee (right leg)
RANKLE=[RANKLE_y RANKLE_z];
Ankle_right = RKNEE-RANKLE;

u = Ankle_right;
v = femur_right;

cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!

knee_angle = atan2(cp, dp);% * 180/pi;

% Ankle angle
RTOE = [RTOE_y RTOE_z];
Foot_right = RTOE - RANKLE;

u = Ankle_right;
v = Foot_right;

cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!

foot_angle = (95*pi/180) + atan2(cp, dp);% * 180/pi;


%plot(time(124:212),foot_angle(124:212))


%% Moment

dt = time(3) - time(2);

ankle_speed_y = gradient(RANKLE_y,dt);
ankle_acc_y = gradient(ankle_speed_y, dt);

ankle_speed_z = gradient(RANKLE_z,dt);
ankle_acc_z = gradient(ankle_speed_z, dt);

ankle_angle_speed = gradient(foot_angle,dt);
ankle_angle_acc = gradient(ankle_angle_speed,dt);

foot_length = norm(Foot_right(1, :));
foot_COM_factor = 0.5;

dy = foot_COM_factor * foot_length * cos(foot_angle);
dz = foot_COM_factor * foot_length * sin(foot_angle);


%plot(time(124:212), ankle_acc_y(124:212))
%figure;
%plot(time(124:212), ankle_speed_y(124:212))




