schema = open("./schema", "r").readlines()


def print_cast_required(schema):
    st = ""
    for column in schema:
        column = column.strip()
        if column[len(column) - 1] == ",":
            column = column[:-1]
        st += "\ncast( {0} as ),".format(column)
    st = st[:-1]
    return st


def tf_schema_maker(schema):
    st = ""
    for column in schema:
        column = column.strip()
        if column[len(column) - 1] == ",":
            column = column[:-1]
        st += "\n{\n\t"
        st += '"name": "{0}"'.format(column)
        st += ',\n\t"type": "STRING",\n\t"mode": "NULLABLE",\n\t'
        st += '"description": "{0}"'.format(column)
        st += "\n},"

    # remove last comma
    st = st[:-1]
    return st


# uncomment below line to print required for terraform schema json
# print(tf_schema_maker(schema))


print(print_cast_required(schema))
