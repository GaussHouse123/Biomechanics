close all;
clear all;
clc;

%% Setup files

name_motion={'Walking'    'Jogging'   'Crouch'};
name_grf   ={'Walking_FP' 'Jogging_FP' 'Crouch_FP'};

index = 1; % select the motion to be loaded and visualized e.g., index=1 -> NormWalk

%% Read data (data files should be in the same folder as the .m file)

file_dir = pwd;
data_trc = readtable(fullfile(file_dir,[name_motion{index} '.csv']));
data_grf = readtable(fullfile(file_dir,[name_grf{index} '.csv']));


%% Downsample ground reaction data, so it has the same length as marker trajectory

data_grf_s = downsample(data_grf,10);
time=data_grf_s.Time;

%% Assign the uploaded table to variables in MATLAB
toMeters = 1/1000; % data is originally in mm, it has to be divided by 1000 to have it in meters

% Thorax origin
TRXO_y = data_trc.TRXO_Y * toMeters; % horizontal coordinate of the thorax origin
TRXO_z = data_trc.TRXO_Z * toMeters; % vertical coordinate of the thorax origin

% Thorax proximal
TRXP_y = data_trc.TRXP_Y * toMeters; % horizontal coordinate of the thorax proximal
TRXP_z = data_trc.TRXP_Z * toMeters; % vertical coordinate of the thorax proximal

% Pelvis proximal
PELP_y = data_trc.PELP_Y * toMeters; % horizontal coordinate of the pelvis proximal
PELP_z = data_trc.PELP_Z * toMeters; % vertical coordinate of the pelvis proximal

% Pelvis origin
PELO_y = data_trc.PELO_Y * toMeters; % horizontal coordinate of the pelvis origin
PELO_z = data_trc.PELO_Z * toMeters; % vertical coordinate of the pelvis origin

% Right hip
RHJC_y = data_trc.RHJC_Y * toMeters; % horizontal coordinate of the right hip
RHJC_z = data_trc.RHJC_Z * toMeters; % vertical coordinate of the right hip

% Left hip
LHJC_y = data_trc.LHJC_Y * toMeters; % horizontal coordinate of the left hip
LHJC_z = data_trc.LHJC_Z * toMeters; % vertical coordinate of the left hip

% Right knee
RKJC_y = data_trc.RKJC_Y * toMeters; % horizontal coordinate of the right knee
RKJC_z = data_trc.RKJC_Z * toMeters; % vertical coordinate of the right knee

% Left knee
LKJC_y = data_trc.LKJC_Y * toMeters; % horizontal coordinate of the left knee
LKJC_z = data_trc.LKJC_Z * toMeters; % vertical coordinate of the left knee

% Right ankle
RAJC_y = data_trc.RAJC_Y * toMeters; % horizontal coordinate of the right ankle
RAJC_z = data_trc.RAJC_Z * toMeters; % vertical coordinate of the right ankle

% Left ankle
LAJC_y = data_trc.LAJC_Y * toMeters; % horizontal coordinate of the left ankle
LAJC_z = data_trc.LAJC_Z * toMeters; % vertical coordinate of the left ankle

% Right toe
RTOO_y = data_trc.RTOO_Y * toMeters; % horizontal coordinate of the right toe
RTOO_z = data_trc.RTOO_Z * toMeters; % vertical coordinate of the right toe

% Left toe
LTOO_y = data_trc.LTOO_Y * toMeters; % horizontal coordinate of the left toe
LTOO_z = data_trc.LTOO_Z * toMeters; % vertical coordinate of the left toe 

% FP1
FP1_force_y = data_grf_s.FP1_Force_Y; % horizontal coordinate of the ground reaction force in FP1
FP1_force_z = data_grf_s.FP1_Force_Z; % vertical coordinate of the ground reaction force in FP1
FP1_COP_y = (600 - data_grf_s.FP1_COP_Y) * toMeters; % horizontal coordinate of the COP in FP1
FP1_COP_z = data_grf_s.FP1_COP_Z * toMeters; % vertical coordinate of the COP in FP1

% FP2
FP2_force_y = data_grf_s.FP2_Force_Y; % horizontal coordinate of the ground reaction force in FP2
FP2_force_z = data_grf_s.FP2_Force_Z; % vertical coordinate of the ground reaction force in FP2
FP2_COP_y = (-600 - data_grf_s.FP2_COP_Y) * toMeters; % horizontal coordinate of the COP in FP2
FP2_COP_z = data_grf_s.FP2_COP_Z*toMeters; % vertical coordinate of the COP in FP2

%% Run a simple animation for visualization purposes only

run_animation = false ;
color_body = "#0077be";
row = height(data_trc);

if run_animation == true
    figure('color','w','Position', [10 10 1200 700]);

    % Start from frame 50th as the coordinates at the first few frames werenot processed and they are not considered in the assignment

    for i=1:1:row

        % Plots the lines of the body parts
        subplot(1,1,1)
        plot([TRXO_y(i),TRXP_y(i)],[TRXO_z(i),TRXP_z(i)],'Color', color_body, 'LineWidth', 2)  % TRXO - TRXP segmemt
        hold on;
        plot([PELO_y(i),PELP_y(i)],[PELO_z(i),PELP_z(i)],'Color', color_body, 'LineWidth', 2)  % PELO - PELP segmemt
        plot([RHJC_y(i),RKJC_y(i)],[RHJC_z(i),RKJC_z(i)],'Color', color_body, 'LineWidth', 2)  % R hip - R knee segmemt
        plot([LHJC_y(i),LKJC_y(i)],[LHJC_z(i),LKJC_z(i)],'Color', color_body, 'LineWidth', 2)  % L hip - L knee segmemt
        plot([RAJC_y(i),RKJC_y(i)],[RAJC_z(i),RKJC_z(i)],'Color', 'g', 'LineWidth', 2)         % R ankle - R knee segmemt
        plot([LAJC_y(i),LKJC_y(i)],[LAJC_z(i),LKJC_z(i)],'Color', 'r', 'LineWidth', 2)         % L ankle - L knee segmemt
        plot([RAJC_y(i), RTOO_y(i)],[RAJC_z(i),RTOO_z(i)],'Color', color_body, 'LineWidth', 2) % R ankle - R toe segmemt
        plot([LAJC_y(i),LTOO_y(i)],[LAJC_z(i),LTOO_z(i)],'Color', color_body, 'LineWidth', 2)  % L ankle - L knee segmemt

        % Plots the text for the name of the joints
        %text(RHJC_y(i), RHJC_z(i),'R hip', 'FontSize', 8)
        %text(LHJC_y(i),LHJC_z(i),'L hip', 'FontSize', 8)
        %text(RKJC_y(i),RKJC_z(i),'R knee', 'FontSize', 8)
        %text(LKJC_y(i),LKJC_z(i),'L knee', 'FontSize', 8)
        %text(RAJC_y(i),RAJC_z(i),'R ankle', 'FontSize', 8)
        %text(LAJC_y(i),LAJC_z(i),'L ankle', 'FontSize', 8)

        % Plots the text for the angle of the joints
        %text(TRXO_y(i), TRXO_z(i), [num2str(trunk_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(PELO_y(i), PELO_z(i), [num2str(pelvis_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RHJC_y(i), RHJC_z(i), [num2str(hip_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RKJC_y(i), RKJC_z(i), [num2str(knee_right_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RAJC_y(i), RAJC_z(i), [num2str(ankle_right_angle(i), '%.1f') '°'], 'FontSize', 12)

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



%% Angle calculations




% Trunk
TRXO = [TRXO_y TRXO_z];
TRXP = [TRXP_y TRXP_z];
trunk_vec = TRXO - TRXP;
z_vec = [zeros(size(trunk_vec, 1), 1), ones(size(trunk_vec, 1), 1)]; % is [0 1] for every frame (which corresponds to the z-axis)

trunk_angle = atan2(cross_product(trunk_vec, z_vec), dot_product(trunk_vec, z_vec)) ;

% Pelvis
PELP = [PELP_y PELP_z];
PELO = [PELO_y PELO_z];
pelvis_vec = PELP - PELO;
z_vec = [zeros(size(pelvis_vec, 1), 1), ones(size(pelvis_vec, 1), 1)]; % is [0 1] for every frame (which corresponds to the z-axis)

pelvis_angle = atan2(cross_product(pelvis_vec, z_vec), dot_product(pelvis_vec, z_vec)) ;



%Known  for both legs
%all anthropometric data taken from ISBN 9780470398180: 
% Biomechanics and Motor Control of Human Movement David A Winter

g=9.81;                 %m/s^2
total_mass=61.9;        %kg
total_length=1.77;      %m
dt =1/100;              %s

%foot

m_f=total_mass*0.0145;
foot_length=0.152*total_length;
center_of_gyration_foot=foot_length*0.475;
I_foot=center_of_gyration_foot^2*m_f;

%shank 

m_s=0.0465*total_mass;
shank_length=(0.285-0.039)*total_length;
center_of_gyration_shank=0.302*shank_length;
I_shank=center_of_gyration_shank^2*m_s;


%thigh

m_t=0.1*total_mass;
thigh_length=(0.530-(0.285+0.039))*total_length;
center_of_gyration_thigh=0.323*thigh_length;
I_thigh=center_of_gyration_thigh^2*m_t;

%--------------------------right leg calculations-----------------------
% Hip (right leg)
right_knee = [RKJC_y RKJC_z];
right_hip =[RHJC_y RHJC_z];
femur_right_vec = right_hip - right_knee;

hip_angle_R = atan2(cross_product(pelvis_vec, femur_right_vec), dot_product(pelvis_vec, femur_right_vec));

% Knee (right leg)
right_ankle = [RAJC_y RAJC_z];
tibia_right_vec = right_knee - right_ankle;

knee_angle_R = atan2(cross_product(tibia_right_vec, femur_right_vec), dot_product(tibia_right_vec, femur_right_vec)) ;

% Ankle (right leg)
right_foot = [RTOO_y RTOO_z];
right_foot_vec = right_foot - right_ankle;

foot_angle_R = 95 * pi/180+ atan2(cross_product(tibia_right_vec, right_foot_vec), dot_product(tibia_right_vec, right_foot_vec)) ;






% -------------------------Moments and forces right leg-------------------


%numerical derivation of the angles on the form y_dot=(y(2)-y(1))/dt for y_dotdot repeat
%with y_dot

ankle_angle_speed_R = diff(foot_angle_R)/dt;
ankle_angle_acc_R = diff(ankle_angle_speed_R)/dt;

knee_angle_speed_R = diff(knee_angle_R)/dt;
knee_angle_acc_R = diff(knee_angle_speed_R)/dt;

hip_angle_speed_R=diff(hip_angle_R)/dt;
hip_angle_acc_R = diff(hip_angle_speed_R)/dt;


%foot


CG_foot_y_R=RAJC_y+0.5*(RTOO_y-RAJC_y);
CG_foot_z_R=RAJC_z+0.5*(RTOO_z-RAJC_z);

CG_foot_speed_z_R = diff(CG_foot_z_R)/dt;
CG_foot_speed_y_R = diff(CG_foot_y_R)/dt;

CG_foot_acc_z_R = diff(CG_foot_speed_z_R)/dt;
CG_foot_acc_y_R = diff(CG_foot_speed_y_R)/dt;


%distances see free body diagram for definition

dy_Af_R = CG_foot_y_R-RAJC_y;
dz_Af_R = RAJC_z-CG_foot_z_R;
dz_Gf_R=CG_foot_z_R-FP2_COP_z;
dy_Gf_R=FP2_COP_y-CG_foot_y_R;

temp=1;
for i=124:212
    A1=[1 0 0;
        0 1 0; 
        -dz_Af_R(i) -dy_Af_R(i) 1
        ];
   b1=[m_f*CG_foot_acc_y_R(i)-FP2_force_y(i); 
        m_f*CG_foot_acc_z_R(i)-FP2_force_z(i)+m_f*g;
        I_foot*ankle_angle_acc_R(i)-(FP2_force_y(i)*dz_Gf_R(i)+FP2_force_z(i)*dy_Gf_R(i))];

    X1_R(:,temp)=A1\b1;
    temp=temp+1;
end
M_foot_R=X1_R(3,:)';
P_foot_R=M_foot_R.*ankle_angle_speed_R(124:212);


%shank



CG_shank_y_R=RAJC_y+0.433*(RKJC_y-RAJC_y);
CG_shank_z_R=RAJC_z+0.433*(RKJC_z-RAJC_z);

CG_shank_speed_z_R = diff(CG_shank_z_R)/dt;
CG_shank_speed_y_R = diff(CG_shank_y_R)/dt;

CG_shank_acc_z_R = diff(CG_shank_speed_z_R)/dt;
CG_shank_acc_y_R= diff(CG_shank_speed_y_R)/dt;

%distances see free body diagram for definition

d_Ks_z_R=RKJC_z-CG_shank_z_R;
d_Ks_y_R=RKJC_y-CG_shank_y_R;
d_As_y_R=CG_shank_y_R-RAJC_y;
d_As_z_R=CG_shank_z_R-RAJC_z;



temp=1;
for i=124:212
A2=[1 0 0 ; 
    0 1 0; 
    -d_Ks_z_R(i) d_Ks_y_R(i) 1];

b2=[m_s*CG_shank_acc_y_R(i)+X1_R(1,temp); 
    m_s*CG_shank_acc_z_R(i)+X1_R(2,temp)+m_s*g ; 
    X1_R(3,temp)+X1_R(1,temp)*d_As_z_R(i)-X1_R(2,temp)*d_As_y_R(i)+I_shank*knee_angle_acc_R(i)];

X2_R(:,temp)=A2\b2;
   temp=temp+1;
end


%hip

CG_thigh_y_R=RKJC_y+0.433*(RHJC_y-RKJC_y);
CG_thigh_z_R=RKJC_z+0.433*(RHJC_z-RKJC_z);

CG_thigh_speed_z_R = diff(CG_thigh_z_R)/dt;
CG_thigh_speed_y_R = diff(CG_thigh_y_R)/dt;

CG_thigh_acc_z_R = diff(CG_thigh_speed_z_R)/dt;
CG_thigh_acc_y_R = diff(CG_thigh_speed_y_R)/dt;

%distances see free body diagram for definition

d_Kt_z_R=CG_thigh_z_R-RKJC_z;
d_Kt_y_R=RKJC_y-CG_thigh_y_R;
d_Ht_y_R=CG_thigh_y_R-RHJC_y;
d_Ht_z_R=RHJC_z-CG_thigh_z_R;


temp=1;
for i=124:212
    A3=[1 0 0 ; 
        0 1 0; 
        -d_Ht_z_R(i) -d_Ht_y_R(i) 1];

    b3=[m_t*CG_thigh_acc_y_R(i)+X2_R(1,temp); 
        m_t*CG_thigh_acc_z_R(i)+X2_R(2,temp)+m_t*g ; 
        X2_R(3,temp)+X2_R(1,temp)*d_Kt_z_R(i)+X2_R(2,temp)*d_Kt_y_R(i)+I_thigh*hip_angle_acc_R(i)];

    X3_R(:,temp)=A3\b3;
       temp=temp+1;
end





%--------------------------left leg calculations-----------------------

% Hip (left leg)
left_knee = [LKJC_y LKJC_z];
left_hip =[LHJC_y LHJC_z];
femur_left_vec = left_hip-left_knee;

hip_angle_L = atan2(cross_product(pelvis_vec, femur_left_vec), dot_product(pelvis_vec, femur_left_vec));

% Knee (left leg)
left_ankle = [LAJC_y LAJC_z];
tibia_left_vec =left_knee- left_ankle;

knee_angle_L = atan2(cross_product(tibia_left_vec, femur_left_vec), dot_product(tibia_left_vec, femur_left_vec)) ;

% Ankle (left leg)
left_toe = [LTOO_y LTOO_z];
left_foot_vec =left_toe-left_ankle;

foot_angle_L = 95 * pi/180+ atan2(cross_product(tibia_left_vec,left_foot_vec), dot_product(tibia_left_vec,left_foot_vec)) ;


% -------------------------Moments and forces left leg-------------------



%numerical derivation of the angles on the form y_dot=(y(2)-y(1))/dt for y_dotdot repeat
%with y_dot
left_gait_startframe=168;
left_gait_endframe=257;

% ankle_angle_speed_L=(foot_angle_L(3:end)-foot_angle_L(1:end-2))./(2*dt)
% ankle_angle_acc_L=(ankle_angle_speed_L(3:end)-ankle_angle_speed_L(1:end-2))./(2*dt)
% 
% ankle_angle_acc_L=ankle_angle_acc_L(168-2:257-2);

ankle_angle_speed_L = gradient(foot_angle_L,dt);
ankle_angle_acc_L = gradient(ankle_angle_speed_L,dt);

knee_angle_speed_L = gradient(knee_angle_L,dt);
knee_angle_acc_L = gradient(knee_angle_speed_L,dt);

hip_angle_speed_L= gradient(hip_angle_L,dt);
hip_angle_acc_L = gradient(hip_angle_speed_L,dt);


%foot

%calculate center of gravity for shank segment from using proximal segment length 

CG_foot_y_L=LAJC_y+0.5*(LTOO_y-LAJC_y);
CG_foot_z_L=LAJC_z+0.5*(LTOO_z-LAJC_z);

%calculate center of gravity speeds and accelerations

CG_foot_speed_z_L = gradient(CG_foot_z_L,dt);
CG_foot_speed_y_L = gradient(CG_foot_y_L,dt);

CG_foot_acc_z_L = gradient(CG_foot_speed_z_L,dt);
CG_foot_acc_y_L = gradient(CG_foot_speed_y_L,dt);

%distances see free body diagram for definition

dy_Af_L = CG_foot_y_L-LAJC_y;
dz_Af_L = LAJC_z-CG_foot_z_L;
dz_Gf_L=CG_foot_z_L-FP1_COP_z;
dy_Gf_L=FP1_COP_y-CG_foot_y_L;


%preallocate space 

FA_y_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
FA_z_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
MA_L=zeros(length(left_gait_startframe:left_gait_endframe),1);

%calculate knee forces/moment
    temp=1;

for i=left_gait_startframe:left_gait_endframe
     FA_y_L(temp)=m_f*CG_foot_acc_y_L(i)-FP1_force_y(i);
     FA_z_L(temp)=m_f*CG_foot_acc_z_L(i)-FP1_force_z(i)+m_f*g;
     MA_L(temp)=dz_Af_L(i)*FA_y_L(temp)+dy_Af_L(i)*FA_z_L(temp)+I_foot*ankle_angle_acc_L(i)-(FP1_force_y(i)*dz_Gf_L(i)+FP1_force_z(i)*dy_Gf_L(i));  
    temp=temp+1;
end

%shank

%calculate center of gravity for shank segment from using proximal segment length 

CG_shank_y_L=LAJC_y+0.433*(LKJC_y-LAJC_y);
CG_shank_z_L=LAJC_z+0.433*(LKJC_z-LAJC_z);

%calculate center of gravity speeds and accelerations

CG_shank_speed_z_L = gradient(CG_shank_z_L,dt);
CG_shank_speed_y_L = gradient(CG_shank_y_L,dt);

CG_shank_acc_z_L = gradient(CG_shank_speed_z_L,dt);
CG_shank_acc_y_L= gradient(CG_shank_speed_y_L,dt);

%distances see free body diagram for definition

d_Ks_z_L=LKJC_z-CG_shank_z_L;
d_Ks_y_L=LKJC_y-CG_shank_y_L;
d_As_y_L=CG_shank_y_L-LAJC_y;
d_As_z_L=CG_shank_z_L-LAJC_z;

%preallocate space 

FK_y_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
FK_z_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
MK_L=zeros(length(left_gait_startframe:left_gait_endframe),1);

%calculate knee forces/moment
    temp=1;
for i=left_gait_startframe:left_gait_endframe
     
    FK_y_L(temp)=m_s*CG_shank_acc_y_L(i)+FA_y_L(temp);
    FK_z_L(temp)=m_s*CG_shank_acc_z_L(i)+FA_z_L(temp)+m_s*g;
    MK_L(temp)=MA_L(temp)+FA_y_L(temp)*d_As_z_L(i)-FA_z_L(temp)*d_As_y_L(i)+I_shank*knee_angle_acc_L(i)+d_Ks_z_R(i)*FK_y_L(temp)-d_Ks_y_L(i)* FK_z_L(temp);
   
    temp=temp+1;
end


%hip

CG_thigh_y_L=LKJC_y+0.433*(LHJC_y-LKJC_y);
CG_thigh_z_L=LKJC_z+0.433*(LHJC_z-LKJC_z);

CG_thigh_speed_z_L = gradient(CG_thigh_z_L,dt);
CG_thigh_speed_y_L = gradient(CG_thigh_y_L,dt);

CG_thigh_acc_z_L = gradient(CG_thigh_speed_z_L,dt);
CG_thigh_acc_y_L = gradient(CG_thigh_speed_y_L,dt);

%distances see free body diagram for definition

d_Kt_z_L=CG_thigh_z_L-LKJC_z;
d_Kt_y_L=LKJC_y-CG_thigh_y_L;
d_Ht_y_L=CG_thigh_y_L-LHJC_y;
d_Ht_z_L=LHJC_z-CG_thigh_z_L;


%preallocate space 

FH_y_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
FH_z_L=zeros(length(left_gait_startframe:left_gait_endframe),1);
MH_L=zeros(length(left_gait_startframe:left_gait_endframe),1);

%calculate knee forces/moment

temp=1;
for i=left_gait_startframe:left_gait_endframe
   
    FH_y_L(temp)=m_t*CG_thigh_acc_y_L(i)+FK_y_L(temp);
    FH_z_L(temp)=m_t*CG_thigh_acc_z_L(i)+FK_z_L(temp)+m_t*g;
    MH_L(temp)=MK_L(temp)+FK_y_L(temp)*d_Kt_z_L(i)+FK_z_L(temp)*d_Kt_y_L(i)+I_thigh*hip_angle_acc_L(i)+d_Ht_z_L(i)*FH_y_L(temp)+d_Ht_y_L(i)*FH_z_L(temp);

    temp=temp+1;
end




%--------------------------------plots---------------------------------


%plots
figure(1)
subplot(3,2,1)
plot(time(124:257),trunk_angle(124:257)*180/pi,LineWidth=1.5)
title("Trunk angle")
xlabel("time / s")
ylabel("Trunk angle / deg")

subplot(3,2,2)
plot(time(124:257),pelvis_angle(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Pelvis angle / deg")
title("Pelvis angle")

subplot(3,2,3)
plot(time(124:257),hip_angle_R(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Hip angle / deg")
title("Hip angle")

subplot(3,2,4)
plot(time(124:212),knee_angle_R(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Knee angle / deg")
title("Knee angle")
legend("Right leg")

subplot(3,2,5)
plot(time(124:212),foot_angle_R(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Foot angle / deg")
title("foot angle")
legend("Right leg")

figure(2)
plot((124-124:212-124)*(100/(212-124)),X1_R(3,:)/(61.9))
hold on
plot((168-168:257-168)*(100/(257-168)), MA_L/(61.9))
title("Ankle")
xlabel("gait / %")
ylabel("moment / Nm/kg")
legend("Right leg","Left leg")
hold off

figure(3)
plot((124-124:212-124)*(100/(212-124)),X2_R(3,:)/(61.9))
hold on
plot((168-168:257-168)*(100/(257-168)), MK_L/(61.9))
title("Knee")
xlabel("gait / %")
ylabel("moment / Nm/kg")
legend("Right leg","Left leg")
hold off

figure(4)
plot((124-124:212-124)*(100/(212-124)),X3_R(3,:)/(61.9))
hold on
plot((168-168:257-168)*(100/(257-168)), MH_L/(61.9))
hold off
title("Hip")
xlabel("gait / %")
ylabel("moment / Nm/kg")
legend("Right leg","Left leg")

figure(5)
plot((124-124:212-124)*(100/(212-124)),P_foot_R/(61.9))
xlabel("gait / %")
ylabel("Power / W/kg")



%--------------------------------functions-------------------------------

function cp = cross_product(a_vec, b_vec)
cp = (a_vec(:, 1) .* b_vec(:, 2)) - (a_vec(:, 2) .* b_vec(:, 1));
end

function dp = dot_product(a_vec, b_vec)
dp = (a_vec(:, 1) .* b_vec(:, 1)) + (a_vec(:, 2) .* b_vec(:, 2));
end


% for i=168:257
% plot([RAJC_y(i),RTOO_y(i)],[RAJC_z(i),RTOO_z(i)])
% hold on
% plot(CG_foot_y_R(i),CG_foot_z_R(i),'*')
% pause(0.1)
% hold off
% end


% function [foot_angle]=calculate_foot_angle(TOE,ANKLE,KNEE)
% 
%     Foot =  TOE- ANKLE;
%     shank = KNEE-ANKLE;
% 
%     u = shank;
%     v = Foot;
% 
%     cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
%     dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!
% 
% 
% 
%     foot_angle = (95*pi/180) + atan2(cp, dp);% * 180/pi;
% end
% 
% function [knee_angle]=calculate_knee_angle(ANKLE,KNEE,HIP)
% 
%     femur=HIP-KNEE;
%     shank = KNEE-ANKLE;
% 
%     u = shank;
%     v = femur;
% 
%     cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
%     dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!
% 
%     knee_angle = atan2(cp, dp);% * 180/pi;
% end
% 
% 
% function   [hip_angle]=calculate_hip_angle(KNEE,HIP,PELP,PELO)
% 
% femur=HIP-KNEE;
% Pelvis=PELP-PELO;
% 
% u = femur;
% v = Pelvis;
% 
% cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
% dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!
% 
% hip_angle = atan2(cp, dp) * -1;% * 180/pi *-1;
% end
