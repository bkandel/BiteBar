#!/usr/bin/python
import glob
import os 
import struct 

FilesToConvert = glob.glob('*.dat')
for File in FilesToConvert:
  FileComponents = os.path.splitext(File)
  BaseFileName = FileComponents[0]
  fid = open(File, 'rb')
  BinaryString = fid.read()
  AsciiData = []
  i = 115
  while (i + 28) < len(BinaryString):
    AsciiData.append(struct.unpack('>Iffffff', BinaryString[i:i+28]))
    i = i + 28
  fid.close()

  outfile = open(BaseFileName + '.txt', 'w')
  for line in AsciiData:
    outfile.write(str(line).strip('()') + '\n')
