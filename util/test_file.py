from tempfile import NamedTemporaryFile
import shutil
import csv
import time

filename = 'database.csv'
tempfile = NamedTemporaryFile(mode='w', delete=False)

fields = ['sn', 'gw', 'ew', 'ci']

gaze = [5, 5, 2, 2, 2, 1.5, 1.5, 1.5, 2, 1, 1, 0, 0, 0]
emotion = [0.9, 0.9, 0.6, 0.6, 0.6, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]

i = 0
x = 0
def writer(header, data, filename, option):
    with open (filename, "w", newline = "") as csvfile:

        if option == "update":
            writer = csv.DictWriter(csvfile, fieldnames = header)
            writer.writeheader()
            writer.writerows(data)

def updater(filename):
    with open(filename, newline= "") as file:
        readData = [row for row in csv.DictReader(file)]
        
        for x in range(28):
            readData[x]['gw'] = gaze[x]
            readData[x]['ew'] = emotion[x]
            readData[x]['ci'] = gaze[x]*emotion[x]
            x+=1
            

    readHeader = readData[0].keys()
    writer(readHeader, readData, filename, "update")

updater(filename)