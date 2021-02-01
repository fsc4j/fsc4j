curl -T plugins/org.eclipse.jdt.core_3.24.0.vfsc4j_0_5_0-202102012041.jar -u bart-jacobs:$BINTRAY_API_KEY https://api.bintray.com/content/fsc4j/fsc4j/org.eclipse.jdt.core_fsc4j/0.5.0/plugins/org.eclipse.jdt.core_3.24.0.vfsc4j_0_5_0-202102012041.jar
curl -T features/org.eclipse.jdt_3.18.600.vfsc4j-0_5_0.jar -u bart-jacobs:$BINTRAY_API_KEY https://api.bintray.com/content/fsc4j/fsc4j/org.eclipse.jdt_fsc4j/0.5.0/features/org.eclipse.jdt_3.18.600.vfsc4j-0_5_0.jar
curl -T artifacts.jar -u bart-jacobs:$BINTRAY_API_KEY https://api.bintray.com/content/fsc4j/fsc4j/artifacts.jar
curl -T content.jar -u bart-jacobs:$BINTRAY_API_KEY https://api.bintray.com/content/fsc4j/fsc4j/content.jar
