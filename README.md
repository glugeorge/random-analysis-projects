# Random Analysis Projects
This ReadMe keeps track of some neat projects I've done in addition to projects I've contributed to that aren't stored on my GitHub. I think these are some pretty cool projects that you should check out!

## 2022
**Hurricanes tracks and their economic impacts in a changing climate**:  
- Group project found [here](https://github.com/katelmarsh/hurricanes_climate_pred)
- This project used hierarchical clustering to identify two different "classes" of hurricanes that pose a financially damaging risk. It then investigates the evolution of these hurricanes with respect to a changing climate.
- I specifically conducted all the data cleaning/processing and initial k-means clustering for analyzing "financially damaging" hurricanes and how they may evolve with climate change. I also created most of the data visualizations. 

**A physics guided machine learning model for lake temperature prediction**:
- Found in [`Physics Guided Machine Learning for a Lake Stratification Model`](https://github.com/glugeorge/random-analysis-projects/tree/main/Physics%20Guided%20Machine%20Learning%20for%20a%20Lake%20Stratification%20Model)
- This project had us fine-tuning an existing process-guided LSTM model that predicts lake temperature profiles
- Our team attuned this model to use a dynamic learning rate with an SGD optimizer
- I specifically further attuned this model by recognizing that basal depth temperatures of the lake do not vary much, so I trained it on only the top 60% of depths, which still produced similarly accurate predictions for the entire depth profile.
