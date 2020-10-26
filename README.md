# StudentEngagement XAI by Group 1 - DBM140
This project is based on the following repository: https://github.com/sherkhan15/distarctor-Detection_Eyes_Emotions_CI

It was expanded by [Kevin Bekker](https://github.com/KevinBekker), [Huizhong Ye](https://github.com/aaahzyeah) and Jing Li for the DBM140 "Embodying intelligent behavior in social context" course of the Industrial Design department at Eindhoven University of Technology.

This project aims to bring explainability in the process of how the engagement of students is calculated by the agent. It will visualize the overall focus of students in a blob, which will change color and size according to the variables used in the calculation. By interacting with the blob the user can get more detailed information about how the calculation is made, in a visual overview. 

## Installation and running the program
In order to run the XAI Processing sketch dynamically, both the sketch and the Python script need to be running. The repository contains a _database.csv_ file, containing the static data. When running the Processing sketch individually it will use this data to calculate all values and display them in the XAI blob. 
When running the Python script as well, it will update the final row in the csv in order to facilitate dynamic data to the Processing sketch.

### Processing
To run the sketch, please open up and run the file in the blobV5 folder.

### Python
In order to run the Python script run the run_local_cv.py file in the root of the folder. Please check which Python version you are using, this might change the first argument in the command (e.g., python3 instead of python).

```
python run_local_cv.py
```

Install all needed libraries in order to run the program, it will prompt to access your webcam. This is needed for the facial analysis.

