export const data: string = `

INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'MavisePlaisance@teleworm.us', encode(sha256('rexouw3No'::bytea), 'hex'),
'Mavise Plaisance', '4495 Hyde Park Road', 'London', 'N6E 1A9', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'OlivierAllard@armyspy.com', encode(sha256('ietaixeeZ5'::bytea), 'hex'), 'Olivier Allard',
'430 Island Hwy', 'Campbell River', 'V9W 2C9', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'PorterLussier@teleworm.us', encode(sha256('Yu7shohmei'::bytea), 'hex'), 'Porter Lussier',
'2593 Fallon Drive', 'Dungannon', 'N0M 1R0', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'AyaSaindon@rhyta.com', encode(sha256('eYu2oog8'::bytea), 'hex'), 'Aya Saindon',
'3387 Nelson Street', 'Bala', 'P0C 1A0', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'ReneProvencher@gmail.com', encode(sha256('uax1AheeChae'::bytea), 'hex'),
'René Provencher', '1296 Boulevard Cremazie', 'Quebec', 'G1R 1B8', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'DonatRaymond@jourrapide.com', encode(sha256('nae7Lip8ie'::bytea), 'hex'),
'Donat Raymond', '3701 Papineau Avenue', 'Montreal', 'H2K 4J5', FALSE);

INSERT INTO Netflix_Poly.Membre VALUES (1, '', '', '', '', '');

TODO: FILL REST OF DB
`;
