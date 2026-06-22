package com.blooddonor.config;

import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // Allow all internal forwards/includes (critical for JSP) and error dispatches
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
                // Public pages
                .requestMatchers(new AntPathRequestMatcher("/")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/home")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/login")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/register")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/search-donor")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/impact")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/blood-camps")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/verify-otp")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/resend-otp")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/forgot-password")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/verify-forgot-password-otp")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/reset-password**")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/css/**")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/js/**")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/images/**")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/uploads/**")).permitAll()
                .requestMatchers(new AntPathRequestMatcher("/error")).permitAll()
                // Authenticated general
                .requestMatchers(new AntPathRequestMatcher("/profile/**")).authenticated()
                // Role-based access
                .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
                .requestMatchers(new AntPathRequestMatcher("/hospital/register-camp/**")).authenticated()
                .requestMatchers(new AntPathRequestMatcher("/hospital/**")).hasRole("HOSPITAL")
                .requestMatchers(new AntPathRequestMatcher("/volunteer/**")).hasRole("VOLUNTEER")
                .requestMatchers(new AntPathRequestMatcher("/donor/**")).hasRole("DONOR")
                .requestMatchers(new AntPathRequestMatcher("/patient/**")).hasRole("PATIENT")
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler((request, response, authentication) -> {
                    String role = authentication.getAuthorities().iterator().next().getAuthority();
                    if (role.equals("ROLE_ADMIN")) response.sendRedirect("/admin/dashboard");
                    else if (role.equals("ROLE_DONOR")) response.sendRedirect("/donor/dashboard");
                    else if (role.equals("ROLE_PATIENT")) response.sendRedirect("/patient/dashboard");
                    else if (role.equals("ROLE_HOSPITAL")) response.sendRedirect("/hospital/dashboard");
                    else if (role.equals("ROLE_VOLUNTEER")) response.sendRedirect("/volunteer/dashboard");
                    else response.sendRedirect("/");
                })
                .failureUrl("/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessUrl("/login?logout=true")
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/access-denied")
            );

        return http.build();
    }
}
