import os

l = (list(os.walk('.'))[0][2])

for name in l:
    if 'Day' in name:
        os.system(f'mv Day.{name[4:]} Hello.{name[4:]}')

