service = 'https://unifieddatalibrary.com/udl/elset?epoch=%3Enow-1%20days&idOnOrbit=56444';
options = weboptions('Username','ryan.britt1','Password','','CertificateFilename', '', 'ContentType','json', 'ArrayFormat', 'json', 'Timeout', 100); 
data = webread(service,options);