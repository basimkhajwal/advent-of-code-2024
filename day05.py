with open("input/input05.txt") as f: lines = f.readlines()
empty = lines.index("\n")
order   = [list(map(int,s.split("|"))) for s in lines[:empty]]
queries = [list(map(int,s.split(","))) for s in lines[empty+1:]]
part_one = part_two = 0
for query in queries:
    if all(query.index(a)<=query.index(b) for a,b in order if a in query and b in query):
        part_one += query[len(query)//2]
    else:
        for _ in range(len(query)):
            for a, b in order:
                ia = query.index(a) if a in query else -1
                ib = query.index(b) if b in query else -1
                if -1 < ib < ia: query[ia], query[ib] = query[ib], query[ia]
        part_two += query[len(query)//2]
print(part_one)
print(part_two)
