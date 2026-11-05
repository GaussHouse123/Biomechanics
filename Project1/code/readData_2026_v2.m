close all
clear all
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

%%








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
shank_right = RKNEE-RANKLE;

u = shank_right;
v = femur_right;

cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!

knee_angle = atan2(cp, dp);% * 180/pi;

% Ankle angle
RTOE = [RTOE_y RTOE_z];
Foot_right = RTOE - RANKLE;

u = shank_right;
v = Foot_right;

cp = (u(:, 1) .* v(:, 2)) - (u(:, 2) .* v(:, 1)); % cp = cross product, inget annat...
dp = (u(:, 1) .* v(:, 1)) + (u(:, 2) .* v(:, 2)); % dp = dot product, inget annat!



foot_angle = (95*pi/180) + atan2(cp, dp);% * 180/pi;


%plot(time(124:212),foot_angle(124:212))


%% Moment
g=9.81;
total_mass=61.9;
total_length=1.77;
dt =( time(3) - time(2));

% ankle_speed_y = gradient(RANKLE_y,dt);
% ankle_acc_y = gradient(ankle_speed_y, dt);
% 
% ankle_speed_z = gradient(RANKLE_z,dt);
% ankle_acc_z = gradient(ankle_speed_z, dt);
% 
% ankle_angle_speed = gradient(foot_angle,dt);
% ankle_angle_acc = gradient(ankle_angle_speed,dt);
% 
ankle_angle_speed = diff(foot_angle)/dt;
ankle_angle_acc = diff(ankle_angle_speed)/dt;

% foot_length = sqrt(Foot_right(160, 1)^2+Foot_right(160, 2)^2)
foot_length =0.152*total_length;%from ISBN 9780470398180
foot_COM_factor = 0.5;

ankle_speed_y = diff(RANKLE_y)/dt;
ankle_acc_y = diff(ankle_speed_y)/dt;


ankle_speed_z = diff(RANKLE_z)/dt;
ankle_acc_z = diff(ankle_speed_z)/dt;




knee_speed_y = diff(RKNEE_y)/dt;
knee_acc_y = diff(knee_speed_y )/dt;

knee_speed_z = diff(RKNEE_z)/dt;
knee_acc_z = diff(knee_speed_z)/dt;

knee_angle_speed = diff(knee_angle)/dt;
knee_angle_acc = diff(knee_angle_speed)/dt;




hip_angle_speed=diff(hip_angle)/dt;
hip_angle_acc = diff(hip_angle_speed)/dt;


%foot


CG_foot_y=mean([RTOE_y';RANKLE_y']);
CG_foot_z=mean([RTOE_z';RANKLE_z']);
dy_Af = CG_foot_y'-RANKLE_y;
dz_Af = RANKLE_z-CG_foot_z';
dz_Gf=CG_foot_z'-FP2_COP_z;
dy_Gf=FP2_COP_y-CG_foot_y';


CG_foot_speed_z = diff(CG_foot_z)/dt;
CG_foot_speed_y = diff(CG_foot_y)/dt;

CG_foot_acc_z = diff(CG_foot_speed_z)/dt;
CG_foot_acc_y = diff(CG_foot_speed_y)/dt;

m_f=total_mass*0.0145;
center_of_gyration_foot=foot_length*0.475;
I_foot=center_of_gyration_foot^2*m_f;

for i=124:212
    A1=[1 0 0;
        0 1 0; 
        -dz_Af(i) -dy_Af(i) 1
        ];

    b1=[m_f*CG_foot_acc_y(i)-FP2_force_y(i); 
        m_f*CG_foot_acc_z(i)-FP2_force_z(i)+m_f*g;
        I_foot*ankle_angle_acc(i)-(FP2_force_y(i)*dz_Gf(i)+FP2_force_z(i)*dy_Gf(i))];

    X1(:,i)=A1\b1;
end
M_foot=X1(3,124:212)';
P_foot=M_foot.*ankle_angle_speed(124:212);


%shank
m_s=0.0465*total_mass;
% shank_length=sqrt(shank_right(160,1)^2+shank_right(160,2)^2);
shank_length=(0.285-0.039)*total_length;
center_of_gyration_shank=0.302*shank_length;
I_shank=center_of_gyration_shank^2*m_s;



CG_shank_y=RANKLE_y+0.433*(RKNEE_y-RANKLE_y);
CG_shank_z=RANKLE_z+0.433*(RKNEE_z-RANKLE_z);

CG_shank_speed_z = diff(CG_shank_z)/dt;
CG_shank_speed_y = diff(CG_shank_y)/dt;

CG_shank_acc_z = diff(CG_shank_speed_z)/dt;
CG_shank_acc_y = diff(CG_shank_speed_y)/dt;
% CG_shank_y=mean([RKNEE_y';RANKLE_y'])';
% CG_shank_z=mean([RKNEE_z';RANKLE_z'])';

d_Ks_z=RKNEE_z-CG_shank_z;
d_Ks_y=RKNEE_y-CG_shank_y;
d_As_y=CG_shank_y-RANKLE_y;
d_As_z=CG_shank_z-RANKLE_z;




for i=124:212
A2=[1 0 0 ; 
    0 1 0; 
    -d_Ks_z(i) d_Ks_y(i) 1];

b2=[m_s*CG_shank_acc_y(i)+X1(1,i); 
    m_s*CG_shank_acc_z(i)+X1(2,i)+m_s*g ; 
    X1(3,i)+X1(1,i)*d_As_z(i)-X1(2,i)*d_As_y(i)+I_shank*knee_angle_acc(i)];

X2(:,i)=A2\b2;
end

%hip
m_t=0.1*total_mass;
thigh_length=(0.530-(0.285+0.039))*total_length;
center_of_gyration_thigh=0.323*thigh_length;
I_thigh=center_of_gyration_thigh^2*m_t;

CG_thigh_y=RKNEE_y+0.433*(RHIP_y-RKNEE_y);
CG_thigh_z=RKNEE_z+0.433*(RHIP_z-RKNEE_z);



CG_thigh_speed_z = diff(CG_thigh_z)/dt;
CG_thigh_speed_y = diff(CG_thigh_y)/dt;

CG_thigh_acc_z = diff(CG_thigh_speed_z)/dt;
CG_thigh_acc_y = diff(CG_thigh_speed_y)/dt;


d_Kt_z=CG_thigh_z-RKNEE_z;
d_Kt_y=RKNEE_y-CG_thigh_y;
d_Ht_y=CG_thigh_y-RHIP_y;
d_Ht_z=RHIP_z-CG_thigh_z;

for i=124:212
    A3=[1 0 0 ; 
        0 1 0; 
        -d_Ht_z(i) -d_Ht_y(i) 1];

    b3=[m_t*CG_thigh_acc_y(i)+X2(1,i); 
        m_t*CG_thigh_acc_z(i)+X2(2,i)+m_t*g ; 
        X2(3,i)+X2(1,i)*d_Kt_z(i)+X2(2,i)*d_Kt_y(i)+I_thigh*hip_angle_acc(i)];

    X3(:,i)=A3\b3;
end





%plots
subplot(3,2,1)
plot(time(124:257),Trunk_angle(124:257)*180/pi,LineWidth=1.5)
title("Trunk angle")
xlabel("time / s")
ylabel("Trunk angle / deg")

subplot(3,2,2)
plot(time(124:257),Pelvis_angle(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Pelvis angle / deg")
title("Pelvis angle")

subplot(3,2,3)
plot(time(124:257),hip_angle(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Hip angle / deg")
title("Hip angle")

subplot(3,2,4)
plot(time(124:212),knee_angle(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Knee angle / deg")
title("Knee angle")
legend("Right leg")

subplot(3,2,5)
plot(time(124:212),foot_angle(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Foot angle / deg")
title("foot angle")
legend("Right leg")

figure(2)
plot((124-124:212-124)*(100/(212-124)),X1(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(3)
plot((124-124:212-124)*(100/(212-124)),X2(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(4)
plot((124-124:212-124)*(100/(212-124)),X3(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(5)
plot((124-124:212-124)*(100/(212-124)),P_foot/(61.9))
xlabel("gait / %")
ylabel("Power / W/kg")
% for i=124:257
% plot([RANKLE_y(i),RKNEE_y(i)],[RANKLE_z(i),RKNEE_z(i)])
% hold on
% plot(CG_shank_y(i),CG_shank_z(i),'*')
% pause(0.1)
% hold off
% end

