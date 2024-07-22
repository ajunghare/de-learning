schema = open("/home/junghare/repo/se-data-eng-exercise/schema","r").readlines()
st = ""
for column in schema:
    column= column.strip()
    if column[len(column)-1]==",":
        column=column[:-1] 
    st += '\n{\n\t'
    st += '"name": "{0}"'.format(column)
    st += ',\n\t"type": "STRING",\n\t"mode": "NULLABLE",\n\t'
    st += '"description": "{0}"'.format(column)
    st += '\n},'

#remove last comma
st = st[:-1]
print(st)