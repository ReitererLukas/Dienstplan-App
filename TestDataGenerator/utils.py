def getTemplatePath(id: str) -> str:
    return f"calendars/templates/{id}Template.ics"

def getCalendarPath(id: str) -> str:
    return f"calendars/{id}.ics"

def readFile(path) -> str:
    file = open(path,"r", encoding="utf-8")
    text = file.read()
    file.close()
    return text


def writeFile(path, text):
    file = open(path,"w", encoding="utf-8")
    file.write(text)
    file.close()