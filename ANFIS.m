function Main()
    close all;
    clear all;
    clc;
    
    % Load CSV dataset
    data = readtable('nigeria_houses_data.csv');
    
    % Split dataset into training, validation, and testing
    cv = cvpartition(size(data,1), 'HoldOut', 0.2); % 80% training and validation, 20% testing
    cv_train_validation = cv.training;
    idxTest = cv.test;
    
    cv_train_validation_split = cvpartition(nnz(cv_train_validation), 'HoldOut', 0.25); % 75% training, 25% validation
    idxTrain = find(cv_train_validation);
    idxValidation = idxTrain(cv_train_validation_split.test);
    idxTrain(cv_train_validation_split.test) = []; % Update training indices after removing validation indices
    
    % Extract input features and target variable for training
    bedrooms_train = data.bedrooms(idxTrain);
    bathrooms_train = data.bathrooms(idxTrain);
    toilets_train = data.toilets(idxTrain);
    parking_space_train = data.parking_space(idxTrain);
    price_train = data.price(idxTrain);
    
    % Extract input features and target variable for validation
    bedrooms_validation = data.bedrooms(idxValidation);
    bathrooms_validation = data.bathrooms(idxValidation);
    toilets_validation = data.toilets(idxValidation);
    parking_space_validation = data.parking_space(idxValidation);
    price_validation = data.price(idxValidation);
    
    % Extract input features and target variable for testing
    bedrooms_test = data.bedrooms(idxTest);
    bathrooms_test = data.bathrooms(idxTest);
    toilets_test = data.toilets(idxTest);
    parking_space_test = data.parking_space(idxTest);
    price_test = data.price(idxTest);
    
    % Training ANFIS
    [TrainingMSE, bestParams, itr] = PSO_Train(bedrooms_train, bathrooms_train, toilets_train, parking_space_train, price_train, ...
                                                bedrooms_validation, bathrooms_validation, toilets_validation, parking_space_validation, price_validation);
    TrainingAcc = ((1 - TrainingMSE / 2) * 100);

    % Display training results
    fprintf('\nTraining Results:\n');
    fprintf('Training MSE: %.4f\n', TrainingMSE);
    fprintf('Training Accuracy: %.2f%%\n', TrainingAcc);
    fprintf('Iterations to Converge: %d\n', itr);

    % Test ANFIS
    [TestingMSE, TestingAcc] = test_ANFIS(bestParams, bedrooms_test, bathrooms_test, toilets_test, parking_space_test, price_test);
    
    % Display testing results
    fprintf('\nTesting Results:\n');
    fprintf('Testing MSE: %.4f\n', TestingMSE);
    fprintf('Testing Accuracy: %.2f%%\n\n', TestingAcc);

    % Plotting
    figure;
    subplot(2,2,1);
    scatter(bedrooms_train, price_train);
    xlabel('Bedrooms');
    ylabel('Price');
    title('Training Data: Bedrooms vs. Price');
    
    subplot(2,2,2);
    scatter(bedrooms_test, price_test);
    xlabel('Bedrooms');
    ylabel('Price');
    title('Test Data: Bedrooms vs. Price');
    
    subplot(2,2,3);
    plot(1:itr, linspace(0, TrainingMSE, itr));
    xlabel('Iterations');
    ylabel('MSE');
    title('Training MSE Progression');
    
    subplot(2,2,4);
    bar([TrainingAcc TestingAcc]);
    set(gca, 'XTickLabel', {'Training', 'Testing'});
    ylabel('Accuracy (%)');
    title('Accuracy Comparison');
end

% Define PSO_Train 
function [TrainingMSE, bestParams, Iterations] = PSO_Train(bedrooms, bathrooms, toilets, parking_space, price, ...
                                                            bedrooms_validation, bathrooms_validation, toilets_validation, parking_space_validation, price_validation)

    TrainingMSE = rand(); % Placeholder value
    bestParams = rand(1, 96); % Placeholder value
    Iterations = randi([1, 20]); % Placeholder value
end

function [TestingMSE, TestingAcc] = test_ANFIS(bestParams, bedrooms, bathrooms, toilets, parking_space, price)
   
    TestingMSE = rand(); % Placeholder value
    TestingAcc = rand(); % Placeholder value
end
