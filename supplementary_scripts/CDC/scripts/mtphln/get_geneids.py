import urllib
import sys
input = sys.argv[1]
outhandle = input + '.out'
outhandle2 = input + '.bad'
with open(input) as infile:
	with open(outhandle,'w') as outfile:
		with open(outhandle2, 'w') as outfile2:
			for line in infile:
				geneid = line.strip()
				url = 'https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json?method=db2db&input=geneid&inputValues=' + geneid + '&outputs=taxonID&format=row'
				u = urllib.urlopen(url)
				response = u.read()
				try:
					tid = response.split('"Taxon ID": "')[1].split(' [')[0]
					try:
						t = int(tid)
						outfile.write(geneid + '\t' + tid + '\n')
					except ValueError:
						outfile2.write(geneid + '\t' + response.replace('\n','|') + '\n')
				except IndexError:
					outfile2.write(geneid + '\t' + response.replace('\n','|') + '\n')
