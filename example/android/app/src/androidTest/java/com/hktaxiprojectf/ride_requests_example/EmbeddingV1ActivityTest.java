package com.hktaxiprojectf.ride_requests_example;

import androidx.test.rule.ActivityTestRule;
import org.junit.Rule;
import org.junit.runner.RunWith;

import dev.flutter.plugins.integration_test.FlutterTestRunner;
@RunWith(FlutterTestRunner.class)
public class EmbeddingV1ActivityTest {
    @Rule
    public ActivityTestRule<EmbeddingV1Activity> rule =
            new ActivityTestRule<>(EmbeddingV1Activity.class);
}
