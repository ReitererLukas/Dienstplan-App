import fetch from 'node-fetch';
import { Md5 } from 'ts-md5';

export async function fetchDP(link: string): Promise<object | null> {
  let data = await fetch(link).then((response) => {
    if (response.ok) {
      return response.text()
    }
    return null;
  });
  if (!data) {
    return null;
  }
  data = data.split("END:VTIMEZONE")[1]
  let lines = data.split("\r\n");
  lines = lines.filter(l => !l.toUpperCase().startsWith("DTSTAMP") && l != "");
  lines.shift(); // remove first element

  let index = 0;
  let dienste: Map<string, string>[] = [];
  let dienst = new Map<string, string>();
  while (index < lines.length) {
    if (lines[index].toUpperCase() == ("END:VEVENT")) {
      dienste.push(dienst);
      dienst = new Map<string, string>();
      index += 2;
      continue;
    }
    dienst.set(lines[index].split(":")[0].toUpperCase(), lines[index].split(":")[1]);
    index++;
  }

  let currentHashData = dienste.map(d => [...d.entries()].flat().reduce((e1, e2) => e1 + "-" + e2)).reduce((e1, e2) => e1 + "\n" + e2);
  let earliestdtStart: number = dienste.map(d => parseInt(d.get('DTSTART')!.replace('T',''))).reduce((a, b) => a < b ? a : b);
  let nextDpHashData = dienste.filter(d => parseInt(d.get('DTSTART')!.replace('T','')) != earliestdtStart).map(d => [...d.entries()].flat().reduce((e1, e2) => e1 + "-" + e2)).reduce((e1, e2) => e1 + "\n" + e2);
  
  let earliestdtEnd: number = dienste.map(d => parseInt(d.get('DTEND')!.replace('T',''))).reduce((a, b) => a < b ? a : b);
  return { currentHash: Md5.hashStr(currentHashData), hashAfterNext: Md5.hashStr(nextDpHashData), endOfNext: earliestdtEnd }
}