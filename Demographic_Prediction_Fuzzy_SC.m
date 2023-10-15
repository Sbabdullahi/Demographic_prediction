
%In this code, we develop a demographic prediction model using nonlinear
%data from the weight of adaptive neuro fuzzy inference system with SC.
%The code is modified from the individual existing codes of fuzzy decision 
%and clustering algorithms in MATLAB.
%We explain the details of each syntax at the begining of the first line.  


%Load the input data set, could also be a time series data. The data should
%be formatted in .mat file. We import the independent variables (input) and
%dependent variable (output) as separate files as follows
load('Inputfoot_RIGHT.mat');
load('Footsize_Right.mat');



% Declare the input; assign an integer to the imported data for easy
% identification
K = Inputfoot_RIGHT;

%Split the data into training and testing holdout
Training_input = K;
Training_holdout = Training_input(1:78,:);
Training_output = Footsize_Right;
Training_output_holdout = Training_output(1:78,:);
Y = Training_output(79:112,:);




%% We can create a genfisOptions for choosing a clustering mechanism and 
% cluster influence range for our data set, we consider a medium value o.5. 
opt = genfisOptions('SubtractiveClustering','ClusterInfluenceRange',0.5);

% We now generate the fuzzy inference system model using the training data
% and we map the FIS with the clustering option. The rule is the first
% order Sugeno model
fismat = genfis(Training_holdout,Training_output_holdout,opt);




% We verify the model according to the training data set.
% We compute the root mean squared error of the system generated by the 
% training data.
Fuzzy_Training_Model = evalfis(fismat,Training_holdout);
RMSE_Training_Model = norm(Fuzzy_Training_Model-Training_output_holdout)/sqrt(length(Fuzzy_Training_Model));


% We apply the test holdout data to the FIS to validate the model.
% We evaluate the model using the the root mean squared error of the system
% generated by the validation data.
Fuzzy_Testing_Model = evalfis(fismat,Training_input);
RMSE_Testing_Model = norm(Fuzzy_Testing_Model-Training_output)/sqrt(length(Fuzzy_Testing_Model));



% % We plot the output of the model, Fuzzy_Testing_Model, against the 
% validation data,Training_output.
figure
plot(Training_output)
hold on
plot(Fuzzy_Testing_Model,'o')
xlabel('sample length')
title("Prediction Model")
legend('actual','prediction')
hold off





% Note: The model output and validation data are shown as circles and 
% solid blue line, respectively. 
% The plot shows that the model does not perform very well on the validation data.



% We employ the optimization capability of anfis to improve the designed 
% model.
% We use a relatively training period of 300 epochs without 
% using validation data for the first attempt.
 
anfisOpt = anfisOptions('InitialFIS',fismat,'EpochNumber',300,...
                        'InitialStepSize',0.1);
fismat2 = anfis([Training_holdout Training_output_holdout],anfisOpt);




% % After the fuzzy network is improved with optimization, the improved 
% model is evaluated using the training input.
Fuzzy_Training_Model2 = evalfis(fismat2,Training_holdout);
RMSE_Training_Model2 = norm(Fuzzy_Training_Model2-Training_output_holdout)/sqrt(length(Fuzzy_Training_Model2));




% % Validation of improved model to new data set
Fuzzy_Testing_Model2 = evalfis(fismat2,Training_input);
RMSE_Testing_Model2 = norm(Fuzzy_Testing_Model2-Training_output)/sqrt(length(Fuzzy_Testing_Model2));



% % Plot the improved model output obtained using anfis against the testing data.
figure
plot(Training_output)
%ylabel('Training output')
hold on
plot(Fuzzy_Testing_Model2,'--r')
xlabel('Sample length')
title("Final Prediction Model")
legend('actual','prediction')
hold off






B = Fuzzy_Testing_Model2(79:112,:);

%% %% EVALUATION OF TRAINING MODELS USING STATISTICAL METRICS
%% AIC computation
r = Training_output_holdout-Fuzzy_Training_Model2;    % Errors
 SSE1 = norm(r,2)^2;    % normalized SSE Errors
 
 
 n = 78;
p = 78; % total parameters; 



%% RMSE
RMSE2 = sqrt(mean(r.^2));
SE = (r).^2;   % Squared Error
MSE = mean((r).^2);   % Mean Squared Error
RMSE = sqrt(mean((r).^2));  % Root Mean Squared Error

%% MAD
MAD = mad(r);


% MAPE
MAPE= mean((abs(r))./Fuzzy_Training_Model2);
MAPE2 = mean((abs(r))./Fuzzy_Training_Model2)*100;


% R^2
mdl = fitlm(Fuzzy_Training_Model2,Training_output_holdout);
R2 = mdl.Rsquared.Ordinary;


% MAE
MAE = mae(r);


%% %% EVALUATION OF TESTED MODELS USING STATISTICAL METRICS
rt = Y-B;    % Errors
 SSE1t = norm(rt,2)^2;    % normalized SSE Errors
 SSEt = sse(rt,2)^2;   % SSE Errors
 
 nt = 34;
p = 78; % total parameters; 



%% RMSE
RMSE2t = sqrt(mean(rt.^2));

SEt = (rt).^2;   % Squared Error
MSEt = mean((rt).^2);   % Mean Squared Error
RMSEt = sqrt(mean((rt).^2));  % Root Mean Squared Error

%% MAD
MADt = mad(rt);



% MAPE
MAPEt= mean((abs(rt))./B);
MAPE2t = mean((abs(rt))./B)*100;




% R^2
mdlt = fitlm(B,Y);
R2t = mdl.Rsquared.Ordinary;







