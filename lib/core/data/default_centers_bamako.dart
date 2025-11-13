/// Centres essentiels de Bamako (fallback si MapBox ne trouve rien)
/// ⚠️ ATTENTION : Toutes les coordonnées GPS doivent être VÉRIFIÉES sur Google Maps
/// Pour ajouter un centre : Cherchez-le sur Google Maps, récupérez ses vraies coordonnées
class DefaultCenter {
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? plusCode; // Code Plus de Google Maps (ex: "H2H7+76R")
  
  const DefaultCenter({
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.plusCode,
  });
}

/// Liste des centres principaux de Bamako
class DefaultCentersBamako {
  // ⚠️ COORDONNÉES GPS VÉRIFIÉES SUR GOOGLE MAPS
  
  static const List<DefaultCenter> mairies = [
    DefaultCenter(
      name: 'mairie centre de la commune IV',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.630311908417571,
      longitude: -8.035978363109866,
      phone: null, // À compléter si disponible
      plusCode: 'JXH7+JMG, Bamako',
    ),
    DefaultCenter(
      name: 'mairie centre de la commune V',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.607710222226,
      longitude: -8.001914585847171,
      phone: null, // À compléter si disponible
      plusCode: 'JX5X+2C9, Bamako',
    ),

    DefaultCenter(
      name: 'Mairie commune IV Centre Secondaire d\'etat civil d\'Hamdallaye',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.645891329871077,
      longitude: -8.023750424478521,
      phone: null, // À compléter si disponible
      plusCode: 'JXVG+QJP, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE COMMUNE 3',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.65007872465995,
      longitude: -8.0077000865086,
      phone: null, // À compléter si disponible
      plusCode: 'JXXV+82G, Kasse Kelta Ave, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie du district de Bamako',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.648028273034567,
      longitude: -8.002061224478565,
      phone: null, // À compléter si disponible
      plusCode: 'JXWX+P8G, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LA COMMUNE II',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.657861766673372,
      longitude: -7.98330275611419,
      phone: null, // À compléter si disponible
      plusCode: 'M248+9QP, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LA COMMUNE 3',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.656042627550232,
      longitude: -8.026109840372516,
      phone: null, // À compléter si disponible
      plusCode: 'MX3F+VFP, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LA COMMUNE VI',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.60313566300368,
      longitude: -7.964569263109849,
      phone: "78224647", // À compléter si disponible
      plusCode: 'J22P+869, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LA COMMUNE 5',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.607310182968016,
      longitude: -8.002051732425562,
      phone: null, // À compléter si disponible
      plusCode: 'JX4X+96M, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LCOMMUNE II CENTRE SECONDAIRE D\'ETAT CIVIL T.S.F',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.64406544004958,
      longitude: -7.983722471056898,
      phone: null, // À compléter si disponible
      plusCode: 'J2V8+3F4, Bamako',
    ),
    DefaultCenter(
      name: 'MAIRIE DE LA COMMUNE 1',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.671663930078523,
      longitude: -7.954306755162852,
      phone: "72727220", // À compléter si disponible
      plusCode: 'M29W+VCX, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de la commune 1 de Korofina-Sud',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.660358762952798,
      longitude: -7.958083305273429,
      phone: null, // À compléter si disponible
      plusCode: 'M25R+GPF, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.668649267864994,
      longitude: -7.966580543022183,
      phone: null,// À compléter si disponible
      plusCode:'Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de sans-fil',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.648454708633531,
      longitude: -7.9731988096882445,
      phone: null,// À compléter si disponible
      plusCode:'J2WG+MHH, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de la commune V centre secondaire',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.621245995848646,
      longitude: -7.994022156266541,
      phone: null,// À compléter si disponible
      plusCode:'J294+Q4V, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie Municipale de Kalaban Koro',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.558438582024868,
      longitude: -8.00391999379419,
      phone: null,// À compléter si disponible
      plusCode:'HX4W+JG4, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de la commune rurale du mandé',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.555518189141093,
      longitude: -8.08612657105688,
      phone: null,// À compléter si disponible
      plusCode:'HW37+HG, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de Missabougou',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.635459140588722,
      longitude: -7.921056901761906,
      phone: null,// À compléter si disponible
      plusCode:'J3MH+HHP, Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Mairie de Sabalibougou Courani',
      type: 'mairie',
      address: 'Bamako, Mali',
      latitude: 12.656447607878894,
      longitude: -7.888836063109834,
      phone: null,// À compléter si disponible
      plusCode:'M436+WG4, Bamako',
    ),
  ];
  
  static const List<DefaultCenter> commissariats = [
    DefaultCenter(
      name: 'Commissariat de Police du 14e Arrondissement',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.638647912480245,
      longitude: -8.020449138752845,
      phone: "69158679", // À compléter si disponible
      plusCode: 'JXHH+CCJ, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat du 15e Arrondissement de Bamako',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.60380514097497,
      longitude: -8.025255657075373,
      phone: "20283833", // À compléter si disponible
      plusCode: 'HXWG+W43, Baco-Djicoroni Aci, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat de Police du 5e Arrondissement',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.644677910245091,
      longitude: -8.034182048245784,
      phone: "20294043", // À compléter si disponible
      plusCode: 'JXQ7+JR7, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat de police 18ème arrondissement',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.663436992540852,
      longitude: -8.03280875729649,
      phone: null, // À compléter si disponible
      plusCode: 'MX58+VMC, 123, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat De Police 11eme arrondissement',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.584706611035877,
      longitude: -7.983713605859242,
      phone: "20281005", // À compléter si disponible
      plusCode: 'H2H7+36M, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat 4ème Arrondissement IVe',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.612516278548938,
      longitude: -8.001223065462735,
      phone: "20224247", // À compléter si disponible
      plusCode: 'JX4X+HFP, Bamako',
    ),
    DefaultCenter(
      name: 'Commissariat Police de Sébénikoro',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.587722262939018,
      longitude: -8.001223065462735,
      phone: "20224247", // À compléter si disponible
      plusCode: 'JX4X+HFP, Bamako',
    ),
  ];
  
  static const List<DefaultCenter> tribunaux = [
    DefaultCenter(
      name: 'Tribunal de Grande Instance Commune V',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.610110535092812,
      longitude: -8.004010770078901,
      phone: null, // À compléter si disponible
      plusCode: 'JX4X+32J, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal de la Commune IV',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.651652271186823,
      longitude:  -8.030446620852803,
      phone: null, // À compléter si disponible
      plusCode: 'Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal De Grande Instance De La Commune 3',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.646627420169208,
      longitude:  -8.004010770078901,
      phone: "75017649", // À compléter si disponible
      plusCode: 'J2V2+X8M, Mali',
    ),
    DefaultCenter(
      name: 'Tribunal De Grande Instance De La Commune VI de Bamako',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.597658184296943,
      longitude:  -7.938187775176763,
      phone: null, // À compléter si disponible
      plusCode: 'H3V7+749, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal de grande instance',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.636984323035872,
      longitude:-8.02811405243944,
      phone: null, // À compléter si disponible
      plusCode: 'JXHF+X2G, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal De Commerce De Bamako',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.650719200217464,
      longitude:-8.00202152440286,
      phone: "20213166", // À compléter si disponible
      plusCode: 'JXVX+F72, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal De Grande Instance De La Commune 2',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude: 12.668807910736863,
      longitude:-7.969062541619812,
      phone: "20215356", // À compléter si disponible
      plusCode: 'M25J+V29, Bamako',
    ),
    DefaultCenter(
      name: 'TRIBUNAL DE LA COMMUNE VI DE BAMAKO',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.616213106754318,
      longitude:-7.943313336320557,
      phone: null, // À compléter si disponible
      plusCode: 'J333+HPG, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal Administratif de Bamako',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.609547373137797,
      longitude:-7.93621572298033,
      phone: null, // À compléter si disponible
      plusCode: 'H3R6+RXV, Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Palais de justice de Bamako',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.657118904671815,
      longitude:-8.003506979495716,
      phone: null, // À compléter si disponible
      plusCode: 'J2W2+24H, Bamako',
    ),
    DefaultCenter(
      name: 'Cour d\'Appel de Bamako',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.616248124256423,
      longitude:-7.943082177726797,
      phone: null, // À compléter si disponible
      plusCode: 'H3W6+9QM, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal du travail',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.616918189475456,
      longitude: -7.976727806349311,
      phone: null, // À compléter si disponible
      plusCode: 'J23M+VHC, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal des enfants',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.600166026824418,
      longitude: -7.938275659769089,
      phone: null, // À compléter si disponible
      plusCode: 'H3R6+R4G, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal de la Commune 6',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.569339187734952,
      longitude: -7.943082178091617,
      phone: null, // À compléter si disponible
      plusCode: 'H325+WP9, Bamako',
    ),
    DefaultCenter(
      name: 'Tribunal de Kati',
      type: 'tribunaux',
      address: 'Bamako, Mali',
      latitude:12.747547328065973,
      longitude: -8.072858172799865,
      phone: null, // À compléter si disponible
      plusCode: 'PWWG+5FQ Kati Coco, plaine',
    ),



  ];
  static const List<DefaultCenter> somagep = [
    DefaultCenter(
      name: 'SOMAGEP SA - Société Malienne de Gestion de l\'Eau Potable SA',
      type: 'Somagep',
      address: 'Bamako, Mali',
      latitude:12.62659328881456,
      longitude: -8.01405278052397,
      phone: "20704100", // À compléter si disponible
      plusCode: 'Service de Dépannage : 223, SOMAGEP SIEGE, E708 41, Djicoroni Troukabougou, 66 74 78 32, Bamako',
    ),
    DefaultCenter(
      name: 'Somagep Direction Commerciale Et Clientele',
      type: 'Somagep',
      address: 'Bamako, Mali',
      latitude:12.641166227236466,
      longitude: -8.021605880745085,
      phone: null, // À compléter si disponible
      plusCode: 'JXQH+46F, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Generale de la SOMAGEP',
      type: 'Somagep',
      address: 'Bamako, Mali',
      latitude:12.626928308221707,
      longitude: -8.014739425998616,
      phone: null, // À compléter si disponible
      plusCode: 'Bamako',
    ),
    DefaultCenter(
      name: 'Agence SOMAGEP ACI',
      type: 'Somagep',
      address: 'Bamako, Mali',
      latitude:12.635806162576287,
      longitude:  -8.016799362422557,
      phone: null, // À compléter si disponible
      plusCode: 'JXMM+49F, Bamako',
    ),
    DefaultCenter(
      name: 'SOMAGEP S.A Agence Kalaban Coura',
      type: 'Somagep',
      address: 'Bamako, Mali',
      latitude:12.584704665921123,
      longitude:  -7.991486496639088,
      phone: "20733153", // À compléter si disponible
      plusCode: 'H2J5+G3R Kalaban Coura, Bamako',
    ),
  ];
  static const List<DefaultCenter> edm = [
    DefaultCenter(
      name: 'Energie Du Mali Sa',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.647637379454927,
      longitude:  -7.997171196097815,
      phone: "20704200", // À compléter si disponible
      plusCode: 'Square Patrice Lumumba, Bamako',
    ),
    DefaultCenter(
      name: 'EDM SA',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.661706657324185,
      longitude:  -7.994424614199229,
      phone: "61093115", // À compléter si disponible
      plusCode: 'J2X3+58V, Bamako',
    ),
    DefaultCenter(
      name: 'EDM sa Dép TR',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.63758742054517,
      longitude:  -8.012277396540046,
      phone: "61093115", // À compléter si disponible
      plusCode: 'Bamako',
    ),
    DefaultCenter(
      name: 'Siège Énergie du Mali S A ( EDM S.A)',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.65500709793913,
      longitude:  -7.996484550623168,
      phone: null, // À compléter si disponible
      plusCode: 'J2Q3+P6J, Avenue Du Fleuve, Bamako',
    ),
    DefaultCenter(
      name: 'EDMsa',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.641607451557325,
      longitude:  -8.029443533406216,
      phone: null, // À compléter si disponible
      plusCode: 'JXHF+X2G A côté du palais des sports, Bamako',
    ),
    DefaultCenter(
      name: 'Central thermique EDM Dar Salam',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.666396244186895,
      longitude:  -8.010217460116104,
      phone: "20225393", // À compléter si disponible
      plusCode: 'MX3Q+3PM, Bamako',
    ),
    DefaultCenter(
      name: 'EDM Sa Lafiabougou',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.652327224928362,
      longitude:  -8.040429861000565,
      phone: "20202023", // À compléter si disponible
      plusCode: 'JXQ6+75J, Bamako',
    ),
    DefaultCenter(
      name: 'EDM-SA Département Logistique Et Gestion Des Patrimoines',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.66706617812609,
      longitude:  -8.010217460116104,
      phone: "20233215", // À compléter si disponible
      plusCode: 'MX3Q+3G9, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Etudes et Travaux EDM SA',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.647637379454927,
      longitude:  -8.03081682435551,
      phone: null, // À compléter si disponible
      plusCode: 'JXP9+VXR, Bamako',
    ),
    DefaultCenter(
      name: 'EDM sa production',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.660366759523313,
      longitude:  -7.958719049517594,
      phone: null, // À compléter si disponible
      plusCode: 'Bamako',
    ),
    DefaultCenter(
      name: 'Centrale thermique EDM sa',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.666396289695518,
      longitude:  -8.006784194693239,
      phone: "66959416", // À compléter si disponible
      plusCode: 'Bamako',
    ),
    DefaultCenter(
      name: 'EDM-sa Point d\'accueil de Banankaboukou',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.606095036605648,
      longitude:  -7.942926165551086,
      phone: "20207491", // À compléter si disponible
      plusCode: 'H3Q5+9FC, Bamako',
    ),
    DefaultCenter(
      name: 'CPP EDM SA',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.632477105755404,
      longitude:  -8.014788704878882,
      phone: "66747832", // À compléter si disponible
      plusCode: 'B.P. E708, 41, Djicoroni Troukabougou SOMAGEP SIEGE - Service de Dépannage : 223 66 74 78 32',
    ),
    DefaultCenter(
      name: 'EDM-SA PROJET REGIONAL D\'ACCES A L\'ELECTRICITE PRAE-BESTE',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.655926863791628,
      longitude:  -8.003115731809887,
      phone: null, // À compléter si disponible
      plusCode: 'JXQW+MX8, Bamako',
    ),
    DefaultCenter(
      name: 'EDM',
      type: 'edm',
      address: 'Bamako, Mali',
      latitude: 12.617066093229402,
      longitude:  -8.007235604657769,
      phone: "60615145", // À compléter si disponible
      plusCode: 'JX4R+GPQ, Bamako',
    ),

  ];
  static const List<DefaultCenter> transports = [
    DefaultCenter(
    name: 'Direction Générale des Transports DGT',
    type: 'transport',
    address: 'Bamako, Mali',
    latitude: 12.650148171367269,
    longitude:  -8.001666089883665,
    phone: "60615145", // À compléter si disponible
    plusCode: 'JXXX+W8M, Bamako',
  ),
    DefaultCenter(
      name: 'ministere des transport ONT',
      type: 'transport',
      address: 'Bamako, Mali',
      latitude: 12.601425888434495,
      longitude:  -7.959648808924352,
      phone: "66097245", // À compléter si disponible
      plusCode: 'J22R+F62, Bamako',
    ),
  ];
  static const List<DefaultCenter> ministeres = [
    DefaultCenter(
      name: 'Direction Regionale des Domaines et du Cadastre',
      type: 'ministeres',
      address: 'Bamako, Mali',
      latitude: 12.652789582594197,
      longitude:  -8.000769201567131,
      phone: "20234192", // À compléter si disponible
      plusCode: 'MX2X+MMG, Ave De La Liberte, Bamako',
    ),
    DefaultCenter(
      name: 'Domaine Urbanisme',
      type: 'ministeres',
      address: 'Bamako, Mali',
      latitude: 12.648350593623373,
      longitude:  -7.997250148532087,
      phone: null, // À compléter si disponible
      plusCode: 'J2X3+36J, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Nationale des Affaires Judiciaires et du Sceau',
      type: 'ministeres',
      address: 'Bamako, Mali',
      latitude: 12.595313919109806,
      longitude:  -7.93703539173357,
      phone: "20202451", // À compléter si disponible
      plusCode: ' H3V7+X5Q, Bamako',
    ),
  ];
  static const List<DefaultCenter> douanes = [
    DefaultCenter(
      name: 'Direction Générale de la Douane Malienne',
      type: 'douanes',
      address: 'Bamako, Mali',
      latitude: 12.586974677613549,
      longitude:  -7.93993122077039,
      phone: "20205774", // À compléter si disponible
      plusCode: ' H3M6+M26, Bamako',
    ),
    DefaultCenter(
      name: 'DIRECTION DU RENSEIGNEMENT ET DES ENQUETES DOUANIERES',
      type: 'douanes',
      address: 'Bamako, Mali',
      latitude: 12.586974677613549,
      longitude:  -7.945081061830241,
      phone: null, // À compléter si disponible
      plusCode: ' H3M4+68J, Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Générale des Douanes',
      type: 'douanes',
      address: 'Bamako, Mali',
      latitude: 12.547525398559777,
      longitude:  -8.122104719376358,
      phone: null, // À compléter si disponible
      plusCode: 'GVVG+6X, Ntanfaramba',
    ),
    DefaultCenter(
      name: 'Poste de Douane de Samè',
      type: 'douanes',
      address: 'Bamako, Mali',
      latitude: 12.677486750336776,
      longitude:  -8.041084603482338,
      phone: null, // À compléter si disponible
      plusCode: 'MXF5+MH3, Bamako',
    ),
    DefaultCenter(
      name: 'Immeuble Mamadou Bah',
      type: 'douanes',
      address: 'Bamako, Mali',
      latitude: 12.590269393262508,
      longitude:  -7.945464610325705,
      phone: "20204581", // À compléter si disponible
      plusCode: 'H3P4+Q56, Bamako',
    ),
  ];
  static const List<DefaultCenter> impots = [
    DefaultCenter(
      name: 'Direction générale des impôts du district, centre IV des impots de Bamako',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.647400606691685,
      longitude:  -8.03189420171724,
      phone: "20204581", // À compléter si disponible
      plusCode: 'JXV8+FX7, Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Générale des Impôts (DGI)',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.636680626527511,
      longitude:  -8.015929694431689,
      phone: "20299999", // À compléter si disponible
      plusCode: 'JXJP+V58, Bamako',
    ),
    DefaultCenter(
      name: 'Centre Des Impôts DME',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.637350638466094,
      longitude:  -8.028289312975343,
      phone: null, // À compléter si disponible
      plusCode: 'JXMC+RJH, Bamako',
    ),
    DefaultCenter(
      name: 'Centre des Impôts des Moyennes Entreprises : CIME2',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.62545766549233,
      longitude:  -8.033267492666532,
      phone: "79330556", // À compléter si disponible
      plusCode: 'JXC8+QF7, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Nationale Du Trésor Publique',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.638858158904815,
      longitude:  -8.015758033063038,
      phone: "20225866", // À compléter si disponible
      plusCode: 'JXMP+92X, Bamako',
    ),
    DefaultCenter(
      name: 'impot',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.638020648647968,
      longitude:  -8.029147619818652,
      phone: "20225866", // À compléter si disponible
      plusCode: 'JXMC+RJH, Bamako',
    ),
    DefaultCenter(
      name: 'Direction des Impôts du District',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.650583014348351,
      longitude:  -7.980395789535065,
      phone: null, // À compléter si disponible
      plusCode: 'Cowrie Shell Monument, Bamako',
    ),
    DefaultCenter(
      name: 'Direction Natinale du Tresor Et de la Comptabilité Publique',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.631372910764831,
      longitude:  -8.027942385847192,
      phone: null, // À compléter si disponible
      plusCode: 'JXHF+X2G, Bamako',
    ),
    DefaultCenter(
      name: 'Ministere de l\'economie et des Finances du Mali',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.630284115010912,
      longitude:  -8.023822512999313,
      phone: "20225858", // À compléter si disponible
      plusCode: 'JXHG+C63, Bamako',
    ),
    DefaultCenter(
      name: 'Centre des Impôts de la Commune 1',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.678821368326217,
      longitude:  -7.955005817635213,
      phone: "20240317", // À compléter si disponible
      plusCode: 'M2GV+HQX, Unnamed Road, Bamako',
    ),
    DefaultCenter(
      name: 'Direction des Impôts de la Commune 6',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.58234176284809,
      longitude:  -7.955229763109861,
      phone: "20208073", // À compléter si disponible
      plusCode: 'H2JV+6XP, Bamako',
    ),
    DefaultCenter(
      name: 'Bangoni impôts',
      type: 'impots',
      address: 'Bamako, Mali',
      latitude: 12.641596310505903,
      longitude:  -8.002347017635223,
      phone: null, // À compléter si disponible
      plusCode: 'JXQW+PV2, Bamako',
    ),

  ];
  
  /// Obtenir les centres selon le type
  static List<DefaultCenter> getCentersByType(String centerType) {
    final lowerType = centerType.toLowerCase();
    
    if (lowerType.contains('commissariat') || lowerType.contains('police')) {
      return commissariats;
    }
    if (lowerType.contains('mairie')) {
      return mairies;
    }
    if (lowerType.contains('tribunal')) {
      return tribunaux;
    }
    if (lowerType.contains('somagep') || lowerType.contains('eau')) {
      return somagep;
    }
    if (lowerType.contains('edm') || lowerType.contains('électricité')) {
      return edm;
    }
    if (lowerType.contains('transports') || lowerType.contains('transports')) {
      return transports;
    }
    if (lowerType.contains('ministère') || lowerType.contains('ministeres')) {
      return ministeres;
    }
    if (lowerType.contains('impôt') || lowerType.contains('impot')) {
      return impots;
    }
    
    return [];
  }
  
  /// Obtenir tous les centres (toutes catégories)
  static List<DefaultCenter> getAllCenters() {
    return [
      ...mairies,
      ...commissariats,
      ...tribunaux,
      ...somagep,
      ...edm,
      ...transports,
      ...ministeres,
      ...impots,
    ];
  }
}
