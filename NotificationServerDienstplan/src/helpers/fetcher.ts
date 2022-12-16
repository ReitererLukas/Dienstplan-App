import fetch from 'node-fetch';
import { Md5 } from 'ts-md5';

export async function fetchDP(link: string): Promise<string | null> {
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
  let lines = data.split("\n");
  data = lines.filter(l => !l.startsWith("DTSTAMP")).reduce((e1, e2) => e1 + "\n" + e2);
  return Md5.hashStr(data);
}