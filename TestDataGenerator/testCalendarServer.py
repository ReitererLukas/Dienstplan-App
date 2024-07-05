from fastapi import FastAPI
from fastapi.responses import FileResponse
from faker import Faker
from datetime import datetime, timedelta, date, time
from random import Random
from functools import reduce
import os
from .utils import readFile, getCalendarPath, getTemplatePath, writeFile

vehicles = ["NEF", "ID", "KDO"]
vehicles.extend(["RTW" for i in range(5)])
vehicles.extend(["BKTW-R" for i in range(2)])
dienste = [
    {"start": timedelta(hours=5), "end": timedelta(hours=13)},
    {"start": timedelta(hours=6), "end": timedelta(hours=14)},
    {"start": timedelta(hours=7), "end": timedelta(hours=15)},
    {"start": timedelta(hours=8), "end": timedelta(hours=16)},
    {"start": timedelta(hours=11), "end": timedelta(hours=19)},
    {"start": timedelta(hours=12), "end": timedelta(hours=20)},
    {"start": timedelta(hours=13), "end": timedelta(hours=21)},
    {"start": timedelta(hours=19), "end": timedelta(hours=29)},
    {"start": timedelta(hours=20), "end": timedelta(hours=30)},
    {"start": timedelta(hours=16), "end": timedelta(hours=20)},
]

eventTemplate: str = readFile('EventTemplate.txt')
calendarTemplate: str = readFile('CalendarTemplate.txt')

# uvicorn testCalendarServer:app --host 0.0.0.0 --port 3000 --reload
app = FastAPI()

# http://localhost:3000/0/id/Private.ics
@app.get('/{dayOffset}/{id}/Private.ics', response_class=FileResponse)
def getDp(dayOffset: int, id: str):

    file_path = getCalendarFile(dayOffset, id)

    return FileResponse(file_path)
    pass

# http://localhost:3000/0/id/text
@app.get('/{dayOffset}/{id}/text', response_model=str)
def getDp(dayOffset: int, id: str) -> str:
    file_path = getCalendarFile(dayOffset, id)

    return readFile(file_path)
    pass

def createCalendarFile(id: str):
    print("Hallo")
    Faker.seed(seed=id)
    fake = Faker('de_AT')
    random = Random(id)
    
    events = []

    for i in range(random.randint(8,12)):
        event = eventTemplate
        vehicle = random.choice(vehicles)
        event = event.replace('{{ vehicle }}', vehicle)
        name = ''
        if not ["ID", "KDO"].__contains__(vehicle):
            if random.randint(1,3)%3 == 0:
                name = f"{fake.name()}, {fake.name()}"
            else:    
                name = fake.name()
        event = event.replace('{{ member }}', name)
        
        event = event.replace('{{ location }}', "Voitsberg")
        event = event.replace('{{ uid }}', fake.uuid4())
        
        events.append(event)
        pass

    calendar = calendarTemplate
    file_path = getTemplatePath(id)
    calendar = calendar.replace("{{ events }}", reduce(lambda e1, e2: f"{e1}\n{e2}", events))
    writeFile(file_path, calendar)

def setTimestamps(dayOffset: int, id: str):
    calendar = readFile(getTemplatePath(id))
    
    timestamp: str = datetime.utcnow().strftime('%Y%m%dT%H%M%SZ')
    calendar = calendar.replace('{{ dtstamp }}', timestamp)
    
    today = datetime.combine(date.today(), time(hour=0))
    random = Random(id+"Dienste")
    dienst = random.choice(dienste)
    while calendar.__contains__('{{ dtstart }}'):
        calendar = calendar.replace('{{ dtstart }}', (today + dienst.get('start') + timedelta(days=dayOffset)).strftime('%Y%m%dT%H%M%S'), 1)
        calendar = calendar.replace('{{ dtend }}', (today + dienst.get('end') + timedelta(days=dayOffset)).strftime('%Y%m%dT%H%M%S'), 1)
        dayOffset += 1
        pass

    writeFile(getCalendarPath(id), calendar)
    pass

def getCalendarFile(dayOffset: int, id: str) -> str:
    if os.path.exists(getCalendarPath(id)) and os.path.exists(getTemplatePath(id)):
        setTimestamps(dayOffset, id)
        pass
    else:
        createCalendarFile(id)
        setTimestamps(dayOffset, id)
        pass
    
    return getCalendarPath(id)
    pass

