package dev.busung.s25uroot

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class TargetProfileTest {
    private val s928b = TargetProfile(
        profileId = "e3q-S928BXXS6DZF2",
        displayName = "Galaxy S24 Ultra SM-S928B | DZF2 / U5DZDP",
        models = setOf("SM-S928B"),
        kernelVersions = setOf("6.1.145"),
        exploit = RemoteArtifact("asset://e3q-S928BXXS6DZF2/cve-2026-43499-app.so", 104128),
        kernelSu = RemoteArtifact("asset://e3q-S928BXXS6DZF2/ksud-e3q-S928BXXS6DZF2-kdp", 4772304),
        kernelReleases = setOf(
            "6.1.145-android14-11-33419968-abS928BXXS6DZF2",
            "6.1.145-android14-11-33419968-abS928BXXU5DZDP",
        ),
        buildTokens = setOf("S928BXXS6DZF2", "S928BXXU5DZDP"),
    )

    private val s928bKernelSuNext = TargetProfile(
        profileId = "e3q-S928BXXU5DZDP-ksunext",
        displayName = "Galaxy S24 Ultra SM-S928B | U5DZDP | KernelSU Next",
        models = setOf("SM-S928B"),
        kernelVersions = setOf("6.1.145"),
        exploit = RemoteArtifact(
            "asset://e3q-S928BXXU5DZDP-ksunext/cve-2026-43499-app.so",
            104128,
            "a539a433305aa4225561f77714123fe5c50ab8ebf9361982cf3a30dcb3b95e57",
        ),
        kernelSu = RemoteArtifact(
            "asset://e3q-S928BXXU5DZDP-ksunext/ksud-e3q-S928BXXU5DZDP-kernelsu-next",
            4199720,
            "d2bd9be09880da3922d5d43905271d9fb02a59fb4ddb5d54303f6e8ed8d2652c",
        ),
        kernelReleases = setOf("6.1.145-android14-11-33419968-abS928BXXU5DZDP"),
        buildTokens = setOf("S928BXXU5DZDP"),
    )

    @Test
    fun matchesExactS928BDzf2() {
        assertTrue(
            s928b.matches(
                snapshot(
                    model = "SM-S928B",
                    kernelRelease = "6.1.145-android14-11-33419968-abS928BXXS6DZF2",
                    buildId = "BP4A.251205.006.S928BXXS6DZF2",
                    fingerprint = "samsung/e3qxxx/e3q:16/BP4A.251205.006/S928BXXS6DZF2:user/release-keys",
                ),
            ),
        )
    }

    @Test
    fun matchesTestedS928BU5Dzdp() {
        val testedDevice = snapshot(
            model = "SM-S928B",
            kernelRelease = "6.1.145-android14-11-33419968-abS928BXXU5DZDP",
            buildId = "BP4A.251205.006.S928BXXU5DZDP",
            fingerprint = "samsung/e3qxeea/e3q:16/BP4A.251205.006/S928BXXU5DZDP:user/release-keys",
        )
        assertTrue(s928b.matches(testedDevice))
        assertTrue(s928bKernelSuNext.matches(testedDevice))
    }

    @Test
    fun rejectsWrongModelAndBuild() {
        assertFalse(
            s928b.matches(
                snapshot(
                    model = "SM-S928Z",
                    kernelRelease = "6.1.145-android14-11-33419968-abS928BXXS6DZF2",
                    buildId = "BP4A.251205.006.S928BXXS6DZF2",
                    fingerprint = "samsung/e3qxxx/e3q:16/BP4A.251205.006/S928BXXS6DZF2:user/release-keys",
                ),
            ),
        )
        assertFalse(
            s928b.matches(
                snapshot(
                    model = "SM-S928B",
                    kernelRelease = "6.1.145-android14-11-33419968-abS928BXXS6CZC1",
                    buildId = "BP4A.251205.006.S928BXXS6CZC1",
                    fingerprint = "samsung/e3qxxx/e3q:16/BP4A.251205.006/S928BXXS6CZC1:user/release-keys",
                ),
            ),
        )
    }

    private fun snapshot(
        model: String,
        kernelRelease: String,
        buildId: String,
        fingerprint: String,
    ) = DeviceSnapshot(
        manufacturer = "samsung",
        model = model,
        device = "e3q",
        kernelRelease = kernelRelease,
        kernelVersionInfo = "#1 SMP PREEMPT Tue Jun 9 08:23:14 UTC 2026",
        machine = "aarch64",
        buildId = buildId,
        fingerprint = fingerprint,
        androidRelease = "16",
        sdk = 36,
        abi = "arm64-v8a",
        pageSize = 4096,
    )
}
