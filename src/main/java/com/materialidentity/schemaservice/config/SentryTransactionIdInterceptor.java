package com.materialidentity.schemaservice.config;

import io.sentry.Sentry;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class SentryTransactionIdInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String transactionId = request.getHeader("X-Transaction-ID");
        if (transactionId != null && !transactionId.isEmpty()) {
            Sentry.configureScope(scope -> {
                scope.setTag("transaction_id", transactionId);
            });
        }
        return true; // Continue with the execution of the request
    }
}