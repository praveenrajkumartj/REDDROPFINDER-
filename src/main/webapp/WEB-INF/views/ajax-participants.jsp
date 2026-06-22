<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.blooddonor.dto.ParticipantDTO, com.blooddonor.service.BloodCampService, org.springframework.web.context.support.WebApplicationContextUtils, org.springframework.context.ApplicationContext" %>
<%
    try {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            out.print("[]");
            return;
        }
        Long campId = Long.parseLong(idStr);
        
        ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        BloodCampService service = ac.getBean(BloodCampService.class);
        
        List<ParticipantDTO> participants = service.getParticipantDetailsForCamp(campId);
        
        // Manual JSON generation to be 100% sure and avoid dependency issues in JSP
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < participants.size(); i++) {
            ParticipantDTO p = participants.get(i);
            json.append("{")
                .append("\"name\":\"").append(p.getName().replace("\"", "\\\"")).append("\",")
                .append("\"email\":\"").append(p.getEmail().replace("\"", "\\\"")).append("\",")
                .append("\"phone\":\"").append(p.getPhone().replace("\"", "\\\"")).append("\",")
                .append("\"city\":\"").append(p.getCity().replace("\"", "\\\"")).append("\",")
                .append("\"bloodGroup\":\"").append(p.getBloodGroup().replace("\"", "\\\"")).append("\"")
                .append("}");
            if (i < participants.size() - 1) json.append(",");
        }
        json.append("]");
        out.print(json.toString());
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
%>
