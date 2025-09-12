Weather Forecast Data Analysis & Prediction Model

Overview
This project focuses on analyzing weather data and building predictive models for weather classification. Using various machine learning algorithms, the goal is to classify weather conditions such as Cloudy, Rainy, Snowy, and Sunny based on historical data.

Dataset
- The dataset was sourced from Hugging Face: https://huggingface.co/datasets/kanishka089/weather
- It includes weather-related features and a target column representing different weather conditions.

Data Preprocessing
- Checked for missing values and ensured data consistency.
- Identified numerical and categorical features.
- Converted categorical variables into numerical form using one-hot encoding.
- Standardized numerical features using MinMax scaling.
- Analyzed feature correlations with heatmaps.

Exploratory Data Analysis (EDA)
- Generated distributions for numerical features.
- Visualized feature relationships using KDE plots.
- Ensured balanced class distribution in the target variable.

Model Training & Evaluation
Several classification models were trained and tested:

1. K-Nearest Neighbors (KNN)
   - Evaluated performance with k=1, 2, and 3.
2. Support Vector Machine (SVM)
   - Implemented with RBF, Polynomial, and Linear kernels.
3. XGBoost Classifier
   - Achieved the highest accuracy among all models.

Model Performance Comparison
- Accuracy scores were computed for all models.
- XGBoost outperformed KNN and SVM in classification accuracy.
- A bar chart was generated to visualize model performance.

Final Model Implementation
- XGBoost was selected as the final model due to its superior accuracy.
- Predictions were mapped back to categorical weather classes.
- The trained model can classify weather conditions based on feature inputs.

Conclusion
This analysis provides a robust weather classification model using machine learning techniques. The project demonstrates effective data preprocessing, model evaluation, and selection of the best-performing algorithm for weather prediction.

