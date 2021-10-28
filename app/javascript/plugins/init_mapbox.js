// app/javascript/plugins/init_mapbox.js
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const lat = mapElement.dataset.lat;
    const long = mapElement.dataset.long;

    // const map = new mapboxgl.Map({
    //   container: 'map',
    //   style: 'mapbox://styles/mapbox/light-v10',
    //   center: [long, lat],
    //   zoom: 16,
    //   pitch: 45
    // });

    // const marker = new mapboxgl.Marker()
    //   .setLngLat([long, lat])
    //   .addTo(map);
    // }


  // mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleGlzZ256YWxleiIsImEiOiJja3VpbHgwa3oxNnl4Mm90NGZ6d2VleWlhIn0.0K81MlaK_Ea0wXQIoVMzRw';
  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v11',
    center: [long, lat],
    zoom: 16,
    pitch: 45
  });

  // const marker1 = new mapboxgl.Marker({ color: 'black', rotation: 0 })
  //   .setLngLat([long, lat])
  //   .addTo(map);


    // Threejs related stuff to load a model
    // parameters to ensure the model is georeferenced correctly on the map
    const modelOrigin = [long, lat];
    const modelAltitude = 0;
    const modelRotate = [Math.PI / 2, 0, 0];

    const modelAsMercatorCoordinate = mapboxgl.MercatorCoordinate.fromLngLat(
      modelOrigin,
      modelAltitude
    );

    // transformation parameters to position, rotate and scale the 3D model onto the map
    const modelTransform = {
      translateX: modelAsMercatorCoordinate.x,
      translateY: modelAsMercatorCoordinate.y,
      translateZ: modelAsMercatorCoordinate.z,
      rotateX: modelRotate[0],
      rotateY: modelRotate[1],
      rotateZ: modelRotate[2],
      /* Since the 3D model is in real world meters, a scale transform needs to be
      * applied since the CustomLayerInterface expects units in MercatorCoordinates.
      */
      scale: modelAsMercatorCoordinate.meterInMercatorCoordinateUnits()
    };

    const THREE = window.THREE;

    // configuration of the custom layer for a 3D model per the CustomLayerInterface
    const customLayer = {
      id: '3d-model',
      type: 'custom',
      renderingMode: '3d',
      onAdd: function (map, gl) {
        this.camera = new THREE.Camera();
        this.scene = new THREE.Scene();

        // create two three.js lights to illuminate the model
        const directionalLight = new THREE.DirectionalLight(0xffffff);
        directionalLight.position.set(100, -70, 100).normalize();
        this.scene.add(directionalLight);

        const directionalLight2 = new THREE.DirectionalLight(0xffffff);
        directionalLight2.position.set(0, 70, 100).normalize();
        this.scene.add(directionalLight2);

        // use the three.js GLTF loader to add the 3D model to the three.js scene
        const loader = new THREE.GLTFLoader();
        loader.load(
          // 'https://docs.mapbox.com/mapbox-gl-js/assets/34M_17/34M_17.gltf',
          // 'assets/Ferret.glb',
          'https://res.cloudinary.com/alexisgonzalez/image/upload/v1635443221/VR-Mobil_dbopa7.glb',
          // 'https://res.cloudinary.com/alexisgonzalez/image/upload/v1635443482/Vespa_hbvil0.glb',
          (gltf) => {
            this.scene.add(gltf.scene);
          }
        );
        this.map = map;

        // use the Mapbox GL JS map canvas for three.js
        this.renderer = new THREE.WebGLRenderer({
          canvas: map.getCanvas(),
          context: gl,
          antialias: true
        });

        this.renderer.autoClear = false;
      },
      render: function (gl, matrix) {
        const rotationX = new THREE.Matrix4().makeRotationAxis(
          new THREE.Vector3(1, 0, 0),
          modelTransform.rotateX
        );
        const rotationY = new THREE.Matrix4().makeRotationAxis(
          new THREE.Vector3(0, 1, 0),
          modelTransform.rotateY
        );
        const rotationZ = new THREE.Matrix4().makeRotationAxis(
          new THREE.Vector3(0, 0, 1),
          modelTransform.rotateZ
        );

        const m = new THREE.Matrix4().fromArray(matrix);
        const l = new THREE.Matrix4()
          .makeTranslation(
            modelTransform.translateX,
            modelTransform.translateY,
            modelTransform.translateZ
          )
          .scale(
            new THREE.Vector3(
              modelTransform.scale * 25,
              -modelTransform.scale * 25,
              modelTransform.scale * 25
            )
          )
          .multiply(rotationX)
          .multiply(rotationY)
          .multiply(rotationZ);

        this.camera.projectionMatrix = m.multiply(l);
        this.renderer.resetState();
        this.renderer.render(this.scene, this.camera);
        this.map.triggerRepaint();
      }
    };

  function rotateCamera(timestamp) {
    // clamp the rotation between 0 -360 degrees
    // Divide timestamp by 100 to slow rotation to ~10 degrees / sec
    map.rotateTo((timestamp / 100) % 360, { duration: 0 });
    // Request the next frame of the animation.
    requestAnimationFrame(rotateCamera);
  }

  map.on('load', () => {
    // Start the animation.
    rotateCamera(0);

    // Add 3d buildings and remove label layers to enhance the map
    const layers = map.getStyle().layers;
    for (const layer of layers) {
      if (layer.type === 'symbol' && layer.layout['text-field']) {
        // remove text labels
        map.removeLayer(layer.id);
      }
    }

    map.addLayer(customLayer);

    map.addLayer({
      'id': '3d-buildings',
      'source': 'composite',
      'source-layer': 'building',
      'filter': ['==', 'extrude', 'true'],
      'type': 'fill-extrusion',
      'minzoom': 15,
      'paint': {
        'fill-extrusion-color': '#E16568',

        // use an 'interpolate' expression to add a smooth transition effect to the
        // buildings as the user zooms in
        'fill-extrusion-height': [
          'interpolate',
          ['linear'],
          ['zoom'],
          15,
          0,
          15.05,
          ['get', 'height']
        ],
        'fill-extrusion-base': [
          'interpolate',
          ['linear'],
          ['zoom'],
          15,
          0,
          15.05,
          ['get', 'min_height']
        ],
        'fill-extrusion-opacity': 0.8
      }
    });
  });

  }
};

export { initMapbox };
