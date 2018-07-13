import turicreate as turi

url = "datasetType/"

data = turi.image_analysis.load_images(url)
list = ['enfj','enfp','entj','entp','esfj','esfp','estj','estp','infj','infp','intj','intp','isfj','isfp','istj','istp']

def get_label(path, list=list):
  for psychoType in list:
       if psychoType in path:
           return psychoType
                      
data["psychoType"] = data["path"].apply(get_label)

data.save("type.sframe")
data.explore()

dataBuffer = turi.SFrame("type.sframe")
trainingBuffers, testingBuffers = dataBuffer.random_split(0.8)
model = turi.image_classifier.create(trainingBuffers, target="psychoType", model="resnet-50")

evaluations = model.evaluate(testingBuffers)
print evaluations["accuracy"]

model.save("type.model")
model.export_coreml("PsychoClassifier.mlmodel")
