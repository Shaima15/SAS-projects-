# SAS-projects

**Project descriptions**

**1- Airbnb price prediction using machine learning**

This project aimed at predicting the price of Airbnb listings using various categorical and numeric variables. Three different models were used namely linear regression 
with lasso selection, decision tree and random forest. Finally, these models were evaluated and compared to select the best model by comparing RMSE across training and
test datasets. 

In this project, I handled extreme values, performed log-transformation to make the data have a normal distribution, created various visualizations, assessed and handled 
multicollinearity, and performed feature engineering and categorization to reduce dimensionality, enhancing model efficiency and predictive accuracy.

Model comparison: 

Out of these three models, the decision tree has the highest performance followed by random forest and linear regression. Based on this, a decision tree should be chosen to predict the price of airbnb listings. However, there is some conflict. Since transparency is important for customers in a business environment, this makes linear regression a better model compared to decision trees despite the fact that the latter can visibly show us variable importance. In my opinion, I choose the linear regression model because even though the adjusted R-square value is moderate, it should be noted that predicting price in the rental related industry is not easy and it is expected to not always achieve high performance in terms of adjusted R-square. The linear model balances simplicity with performance hence to allow stakeholders to make better decisions, linear regression should be chosen and we can give up a slightly lower RMSE for a more interpretable model. 
